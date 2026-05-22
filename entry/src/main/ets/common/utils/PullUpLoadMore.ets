// PullUpLoadMore.ets — 上拉加载更多逻辑工具

import { LoadMoreState } from '../../view/LoadMoreLayout';

/**
 * 上拉加载更多逻辑辅助类
 *
 * 使用示例：
 *   private loadHelper: PullUpLoadMoreHelper = new PullUpLoadMoreHelper(
 *     (state) => { this.loadMoreState = state; },
 *     () => { this.loadNextPage(); }
 *   );
 *
 * 在 List 的 onReachEnd 或 onScrollFrameBegin 中调用 tryLoadMore()。
 */
export class PullUpLoadMoreHelper {

  private onStateChange: (state: LoadMoreState) => void;
  private onLoadMore: () => void;
  private isLoading: boolean = false;
  private hasMore: boolean = true;

  constructor(
    onStateChange: (state: LoadMoreState) => void,
    onLoadMore: () => void
  ) {
    this.onStateChange = onStateChange;
    this.onLoadMore = onLoadMore;
  }

  /**
   * 尝试触发加载更多（在列表接近底部时调用）
   */
  tryLoadMore(): void {
    if (this.isLoading || !this.hasMore) {
      return;
    }
    this.isLoading = true;
    this.onStateChange(LoadMoreState.Loading);
    this.onLoadMore();
  }

  /**
   * 加载完成时调用
   * @param loadedCount 本次加载到的数据条数
   * @param pageSize    每页大小（用于判断是否还有更多）
   */
  onLoadDone(loadedCount: number, pageSize: number): void {
    this.isLoading = false;
    if (loadedCount < pageSize) {
      this.hasMore = false;
      this.onStateChange(LoadMoreState.NoMore);
    } else {
      this.onStateChange(LoadMoreState.Idle);
    }
  }

  /**
   * 加载失败时调用
   */
  onLoadFail(): void {
    this.isLoading = false;
    this.onStateChange(LoadMoreState.Idle);
  }

  /**
   * 重置状态（下拉刷新后调用）
   */
  reset(): void {
    this.isLoading = false;
    this.hasMore = true;
    this.onStateChange(LoadMoreState.Idle);
  }
}
