// CustomRefreshLoadLayout.ets — 刷新/加载综合布局（RefreshLayout + LoadMoreLayout 的组合封装）

import { RefreshLayout, RefreshState } from './RefreshLayout';
import { LoadMoreLayout, LoadMoreState } from './LoadMoreLayout';

/**
 * 综合刷新加载布局：将顶部刷新区和底部加载区合并为一个组件，
 * 方便在 Scroll + Column 场景（非 List）中直接嵌入。
 */
@Component
export struct CustomRefreshLoadLayout {

  @Prop refreshState: RefreshState = RefreshState.Idle;
  @Prop pullOffset: number = 0;
  @Prop loadMoreState: LoadMoreState = LoadMoreState.Idle;

  build() {
    Column() {

      // 顶部刷新区
      RefreshLayout({
        refreshState: this.refreshState,
        pullOffset: this.pullOffset
      })

      // 底部加载区
      LoadMoreLayout({
        loadMoreState: this.loadMoreState
      })

    }
    .width('100%')
  }
}
