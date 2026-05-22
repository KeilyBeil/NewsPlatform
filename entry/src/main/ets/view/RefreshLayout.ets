// RefreshLayout.ets — 下拉刷新提示区域

import { CommonConstant as Const } from '../common/constant/CommonConstant';

export enum RefreshState {
  Idle = 0,
  /** 下拉中（未达到阈值） */
  Pulling = 1,
  /** 已达到阈值，可松开 */
  ReadyToRelease = 2,
  /** 正在刷新 */
  Refreshing = 3,
}

@Component
export struct RefreshLayout {

  /** 当前刷新状态 */
  @Prop refreshState: RefreshState = RefreshState.Idle;

  @Prop pullOffset: number = 0;

  build() {
    Row() {

      if (this.refreshState === RefreshState.Refreshing) {
        // 刷新中：旋转加载图标
        LoadingProgress()
          .width(24)
          .height(24)
          .color($r('app.color.refresh_icon_color'))
          .margin({ right: 8 })

        Text('正在刷新...')
          .fontSize(14)
          .fontColor($r('app.color.refresh_text_color'))

      } else if (this.refreshState === RefreshState.ReadyToRelease) {
        // 可松开刷新
        Text('↑')
          .fontSize(18)
          .fontColor($r('app.color.refresh_icon_color'))
          .margin({ right: 8 })

        Text('松开立即刷新')
          .fontSize(14)
          .fontColor($r('app.color.refresh_text_color'))

      } else if (this.refreshState === RefreshState.Pulling) {
        // 下拉中
        Text('↓')
          .fontSize(18)
          .fontColor($r('app.color.refresh_icon_color'))
          .margin({ right: 8 })

        Text('下拉可以刷新')
          .fontSize(14)
          .fontColor($r('app.color.refresh_text_color'))

      }

    }
    .width('100%')
    .height(this.pullOffset > 0 ? Math.min(this.pullOffset, Const.REFRESH_HEIGHT) : 0)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.refresh_bg_color'))
    .clip(true)
  }
}
