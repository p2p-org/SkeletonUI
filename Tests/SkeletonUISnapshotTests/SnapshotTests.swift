import Combine
import SkeletonUI
import SnapshotTesting
import SwiftUI
import XCTest

extension String: Identifiable {
    public var id: UUID {
        UUID()
    }
}

final class SnapshotTests: XCTestCase {
    func testDefaultText() {
        let one = Text(nil).skeleton(with: true)
        let two = Text(verbatim: nil).skeleton(with: true)
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 50)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testCustomText() {
        let view = Text(nil).skeleton(with: true).appearance(type: .solid()).shape(type: .rectangle).multiline(lines: 2, scales: [1: 0.5]).animation(type: .pulse())
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 50)))
    }
    
    func testCustomSize() {
        let size = CGSize(width: 100, height: 100)
        let view = Text(nil).skeleton(with: true, size: size)
        assertNamedSnapshot(matching: view, as: .image(size: size))
    }

    func testDefaultImage() {
        #if os(macOS)
            let one = Image(nsImage: nil).skeleton(with: true)
        #else
            let one = Image(uiImage: nil).skeleton(with: true)
        #endif
        let two =  Image(nil, scale: .zero, label: Text(String())).skeleton(with: true)
        let three = Image(nil).skeleton(with: true)
        let four = Image(nil, label: Text(String())).skeleton(with: true)
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: three, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: four, as: .image(size: CGSize(width: 100, height: 100)))
    }

    func testCustomImage() {
        #if os(macOS)
            let one = Image(nsImage: nil).skeleton(with: true).shape(type: .circle).animation(type: .none)
        #else
            let one = Image(uiImage: nil).skeleton(with: true).shape(type: .circle).animation(type: .none)
        #endif
        let two =  Image(nil, scale: .zero, label: Text(String())).skeleton(with: true).shape(type: .circle).animation(type: .none)
        let three = Image(nil).skeleton(with: true).shape(type: .circle).animation(type: .none)
        let four = Image(nil, label: Text(String())).skeleton(with: true).shape(type: .circle).animation(type: .none)
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: three, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: four, as: .image(size: CGSize(width: 100, height: 100)))
    }

    func testSystemImage() {
        #if os(macOS)
            let one = Image(nil).skeleton(with: true)
            let two = Image("checkmark").skeleton(with: true).shape(type: .circle).animation(type: .none)
        #else
            let one = Image(systemName: nil).skeleton(with: true)
            let two = Image(systemName: "checkmark").skeleton(with: true).appearance(type: .gradient()).shape(type: .circle).animation(type: .none)
        #endif
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 100)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 100)))
    }

    func testDefaultTextField() {
        let one = TextField(titleKey: nil, text: Binding.constant(String())).skeleton(with: true)
        let two = TextField(titleKey: nil, value: Binding.constant(String()), formatter: NumberFormatter()).skeleton(with: true)
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 50)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testCustomTextField() {
        let one = TextField(titleKey: nil, text: Binding.constant(String())).skeleton(with: true).appearance(type: .gradient(.angular)).shape(type: .ellipse)
        let two = TextField(titleKey: nil, value: Binding.constant(String()), formatter: NumberFormatter()).skeleton(with: true).appearance(type: .gradient(.angular)).shape(type: .ellipse)
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 50)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testDefaultToggle() {
        let one = Toggle(nil, isOn: Binding.constant(false)).skeleton(with: true)
        let two = Toggle(isOn: nil, label: { Text(String()) }).skeleton(with: true)
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 50)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testCustomToggle() {
        let one = Toggle(nil, isOn: Binding.constant(false)).skeleton(with: true).appearance(type: .gradient(.radial)).shape(type: .rounded(.radius(10)))
        let two = Toggle(isOn: nil, label: { Text(String()) }).skeleton(with: true).appearance(type: .gradient(.radial)).shape(type: .rounded(.radius(10)))
        assertNamedSnapshot(matching: one, as: .image(size: CGSize(width: 100, height: 50)))
        assertNamedSnapshot(matching: two, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testDefaultSecureField() {
        let view = SecureField(nil, text: Binding.constant(String())).skeleton(with: true)
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testCustomSecureField() {
        let view = SecureField(nil, text: Binding.constant(String())).skeleton(with: true).appearance(type: .gradient(.angular)).shape(type: .ellipse)
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 50)))
    }

    func testDefaultSkeletonList() {
        let view = SkeletonList(with: [#function]) { loading, item in
            Text(item).skeleton(with: loading)
        }
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 25)))
    }

    func testLoadingSkeletonList() {
        let view = SkeletonList(with: [String]()) { loading, item in
            Text(item).skeleton(with: loading)
        }
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 25)))
    }

    func testDefaultSkeletonForEach() {
        let view = SkeletonForEach(with: [#function]) { loading, item in
            Text(item).skeleton(with: loading)
        }
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 25)))
    }

    func testLoadingSkeletonForEach() {
        let view = SkeletonList(with: [String]()) { loading, item in
            Text(item).skeleton(with: loading)
        }
        assertNamedSnapshot(matching: view, as: .image(size: CGSize(width: 100, height: 25)))
    }
}
