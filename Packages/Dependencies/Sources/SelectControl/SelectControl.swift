import SwiftUI

public struct SelectControl<Item: Equatable>: View {
  let current: Item
  let items: [Item]

  public init(current: Item, items: [Item]) {
    self.current = current
    self.items = items
  }

  public var body: some View {
    HStack(spacing: 4) {
      ForEach(0 ..< items.count, id: \.self) { index in
        RoundedRectangle(cornerRadius: 2)
          .frame(height: 4)
          .foregroundStyle(
            items[index] == current
              ? Color.primary
              : Color(uiColor: UIColor.systemGray2)
          )
      }
    }
  }
}

#Preview("Dark") {
  VStack(spacing: 40) {
    SelectControl(
      current: "Apple",
      items: ["Apple", "Facebook", "Twitter"]
    )

    SelectControl(
      current: "Facebook",
      items: ["Apple", "Facebook", "Twitter"]
    )

    SelectControl(
      current: "Twitter",
      items: ["Apple", "Facebook", "Twitter"]
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background()
  .environment(\.colorScheme, .dark)
}

#Preview("Light") {
  VStack(spacing: 40) {
    SelectControl(
      current: "Apple",
      items: ["Apple", "Facebook", "Twitter"]
    )

    SelectControl(
      current: "Facebook",
      items: ["Apple", "Facebook", "Twitter"]
    )

    SelectControl(
      current: "Twitter",
      items: ["Apple", "Facebook", "Twitter"]
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background()
}
