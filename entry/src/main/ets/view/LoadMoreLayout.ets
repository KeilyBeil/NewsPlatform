// LoadMoreLayout.ets — 上拉加载更多提示区域

/** 加载更多状态 */
export enum LoadMoreState {
  /** 未触发 */
  Idle = 0,
  /** 正在加载 */
  Loading = 1,
  /** 没有更多数据 */
  NoMore = 2,
}

@Component
export struct LoadMoreLayout {

  /** 当前加载状态 */
  @Prop loadMoreState: LoadMoreState = LoadMoreState.Idle;

  build() {
    Row() {

      if (this.loadMoreState === LoadMoreState.Loading) {
        // 加载中
        LoadingProgress()
          .width(20)
          .height(20)
          .color($r('app.color.refresh_icon_color'))
          .margin({ right: 8 })

        Text('加载中...')
          .fontSize(13)
          .fontColor($r('app.color.refresh_text_color'))

      } else if (this.loadMoreState === LoadMoreState.NoMore) {
        // 没有更多
        Text('— 已经到底啦 —')
          .fontSize(13)
          .fontColor($r('app.color.news_source_color'))

      }
      // Idle 状态不显示任何内容

    }
    .width('100%')
    .height(this.loadMoreState !== LoadMoreState.Idle ? 48 : 0)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.news_item_bg'))
  }
}
