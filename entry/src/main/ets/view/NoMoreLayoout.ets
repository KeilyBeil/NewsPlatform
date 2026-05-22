// NoMoreLayout.ets — 已无更多数据时的提示组件（独立版本，可被其他地方单独使用）

@Component
export struct NoMoreLayout {

  build() {
    Row() {

      Text('— 已经到底啦 —')
        .fontSize(13)
        .fontColor($r('app.color.news_source_color'))

    }
    .width('100%')
    .height(48)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.news_item_bg'))
  }
}
