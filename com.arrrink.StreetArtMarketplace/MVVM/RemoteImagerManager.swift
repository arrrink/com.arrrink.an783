//
//  RemoteImagerManager.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 03.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Combine
import Foundation
import UIKit
import SwiftUI


class ASRemoteImageManager
{
    static let shared = ASRemoteImageManager()
    private init() {}

    let cache = ASCache<URL, ASRemoteImageLoader>()

    func load(_ url: URL)
    {
        imageLoader(for: url).start()
    }

    func cancelLoad(for url: URL)
    {
        imageLoader(for: url).cancel()
    }

    func imageLoader(for url: URL) -> ASRemoteImageLoader
    {
        if let existing = cache.value(forKey: url)
        {
            return existing
        }
        else
        {
            let loader = ASRemoteImageLoader(url)
            cache.setValue(loader, forKey: url)
            return loader
        }
    }
}

class ASRemoteImageLoader: ObservableObject
{
    var url: URL

    @Published
    var state: State?
    {
        didSet
        {
            DispatchQueue.main.async
            {
                self.stateDidChange.send()
            }
        }
    }

    public let stateDidChange = PassthroughSubject<Void, Never>()

    init(_ url: URL)
    {
        self.url = url
    }

    enum State
    {
        case loading
        case success(UIImage)
        case failed
    }

    private var cancellable: AnyCancellable?

    var image: UIImage?
    {
        switch state
        {
        case let .success(image):
            return image
        default:
            return nil
        }
    }

    func start()
    {
        guard state == nil else
        {
            return
        }
        DispatchQueue.main.async
        {
            self.state = .loading
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink
        { image in
            if let image = image
            {
                self.state = .success(image)
            }
            else
            {
                self.state = .failed
            }
        }
    }

    func cancel()
    {
        cancellable?.cancel()
        cancellable = nil
        guard case .success = state else
        {
            DispatchQueue.main.async
            {
                self.state = nil
            }
            return
        }
    }
}
final class ASCache<Key: Hashable, Value>
{
    private let wrappedCache = NSCache<WrappedKey, Entry>()
    private let keyTracker = KeyTracker()

    private let entryLifetime: TimeInterval?

    init(entryLifetime: TimeInterval? = nil)
    {
        self.entryLifetime = entryLifetime
        wrappedCache.delegate = keyTracker
    }

    subscript(_ key: Key) -> Value?
    {
        get { value(forKey: key) }
        set { setValue(newValue, forKey: key) }
    }

    func setValue(_ value: Value?, forKey key: Key)
    {
        guard let value = value else
        {
            removeValue(forKey: key)
            return
        }
        let expirationDate = entryLifetime.map { Date().addingTimeInterval($0) }
        let entry = Entry(key: key, value: value, expirationDate: expirationDate)
        setEntry(entry)
    }

    func value(forKey key: Key) -> Value?
    {
        entry(forKey: key)?.value
    }

    func removeValue(forKey key: Key)
    {
        wrappedCache.removeObject(forKey: WrappedKey(key))
    }
}

private extension ASCache
{
    func entry(forKey key: Key) -> Entry?
    {
        guard let entry = wrappedCache.object(forKey: WrappedKey(key)) else
        {
            return nil
        }

        guard !entry.hasExpired else
        {
            removeValue(forKey: key)
            return nil
        }

        return entry
    }

    func setEntry(_ entry: Entry)
    {
        wrappedCache.setObject(entry, forKey: WrappedKey(entry.key))
        keyTracker.keys.insert(entry.key)
    }
}

private extension ASCache
{
    final class KeyTracker: NSObject, NSCacheDelegate
    {
        var keys = Set<Key>()

        func cache(
            _ cache: NSCache<AnyObject, AnyObject>,
            willEvictObject object: Any)
        {
            guard let entry = object as? Entry else
            {
                return
            }

            keys.remove(entry.key)
        }
    }
}

private extension ASCache
{
    final class WrappedKey: NSObject
    {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { key.hashValue }

        override func isEqual(_ object: Any?) -> Bool
        {
            guard let value = object as? WrappedKey else
            {
                return false
            }

            return value.key == key
        }
    }

    final class Entry
    {
        let key: Key
        let value: Value
        let expirationDate: Date?

        var hasExpired: Bool
        {
            if let expirationDate = expirationDate
            {
                // Discard values that have expired
                return Date() >= expirationDate
            }
            return false
        }

        init(key: Key, value: Value, expirationDate: Date? = nil)
        {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

extension ASCache.Entry: Codable where Key: Codable, Value: Codable {}

extension ASCache: Codable where Key: Codable, Value: Codable
{
    convenience init(from decoder: Decoder) throws
    {
        self.init()

        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)
        // Only load non-expired entries
        entries.filter { !$0.hasExpired }.forEach(setEntry)
    }

    func encode(to encoder: Encoder) throws
    {
        // Only save non-expired entries
        let currentEntries = keyTracker.keys.compactMap(entry).filter { !$0.hasExpired }
        var container = encoder.singleValueContainer()
        try container.encode(currentEntries)
    }
}

struct ASRemoteImageView: View
{
    init(_ url: URL, _ ifNeedOverlayFrame: Bool, contentMode : ContentMode)
    {
        self.url = url
        self.ifNeedOverlayFrame = ifNeedOverlayFrame
        self.contentMode = contentMode
        imageLoader = ASRemoteImageManager.shared.imageLoader(for: url)
    }
    let ifNeedOverlayFrame: Bool
    let contentMode: ContentMode
    let url: URL
    @ObservedObject var imageLoader: ASRemoteImageLoader
    var overlay : some View {
        Image("logomain")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("ColorMain"))
            .rotationEffect(Angle(degrees: -15.0))
            .opacity(0.2)
            .aspectRatio(contentMode: .fit)
            .scaledToFit()


    }
    var content: some View
    {
        ZStack
        {
           // Color(.secondarySystemBackground)
           // Image(systemName: "photo")
            self.imageLoader.image.map
            { image in
                VStack {
                if ifNeedOverlayFrame {
                    if contentMode == .fit {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                     .padding()
                    .overlay(overlay)
                        
                    } else {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .overlay(overlay)
                    }
                    
                } else {
                    if contentMode == .fit {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()

                    } else {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()

                    }
                }
            }
            }.transition(AnyTransition.opacity.animation(Animation.default))
        }
        .compositingGroup()
    }

    var body: some View
    {
        content
    }
}
