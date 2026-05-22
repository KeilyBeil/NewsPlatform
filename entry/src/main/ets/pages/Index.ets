// Index.ets — 应用入口页面

import TabBar from '../view/TabBar';

@Entry
@Component
struct Index {

  build() {
    Column() {

      // 顶部标题栏
      Row() {
        Text($r('app.string.news_title'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.title_color'))
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.title_bar_bg'))
      .shadow({ radius: 4, color: '#1A000000', offsetY: 2 })

      // 分类 Tab + 新闻列表
      TabBar()
        .layoutWeight(1)
        .width('100%')

    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_bg_color'))
  }
}
