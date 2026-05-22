// PullDownRefresh.ets — 下拉刷新手势逻辑工具

import { CommonConstant as Const } from '../constant/CommonConstant';
import { RefreshState } from '../../view/RefreshLayout';

/**
 * 下拉刷新手势处理工具类
 *
 * 使用示例（在组件中）：
 *   private pullHelper: PullDownRefreshHelper = new PullDownRefreshHelper(
 *     (state) => { this.refreshState = state; },
 *     (offset) => { this.pullOffset = offset; },
 *     () => { this.onRefresh(); }
 *   );
 *
 * 然后在 gesture(PanGesture) 的回调中调用对应方法。
 */
export class PullDownRefreshHelper {

  private onStateChange: (state: RefreshState) => void;
  private onOffsetChange: (offset: number) => void;
  private onRefreshTriggered: () => void;
  private startY: number = 0;

  constructor(
    onStateChange: (state: RefreshState) => void,
    onOffsetChange: (offset: number) => void,
    onRefreshTriggered: () => void
  ) {
    this.onStateChange = onStateChange;
    this.onOffsetChange = onOffsetChange;
    this.onRefreshTriggered = onRefreshTriggered;
  }

  /**
   * 手势开始时调用
   */
  onPanStart(event: GestureEvent): void {
    this.startY = event.offsetY;
  }

  /**
   * 手势移动中调用（仅在列表顶部时生效）
   * @param event   手势事件
   * @param isAtTop 当前列表是否在顶部
   */
  onPanUpdate(event: GestureEvent, isAtTop: boolean): void {
    const dy = event.offsetY - this.startY;
    if (dy > 0 && isAtTop) {
      const offset = dy * 0.4; // 阻尼系数
      this.onOffsetChange(offset);
      if (offset >= Const.PULL_DOWN_THRESHOLD) {
        this.onStateChange(RefreshState.ReadyToRelease);
      } else {
        this.onStateChange(RefreshState.Pulling);
      }
    }
  }

  /**
   * 手势结束时调用
   * @param currentState 当前刷新状态
   */
  onPanEnd(currentState: RefreshState): void {
    if (currentState === RefreshState.ReadyToRelease) {
      this.onStateChange(RefreshState.Refreshing);
      this.onRefreshTriggered();
    } else {
      animateTo({ duration: 200, curve: Curve.EaseOut }, () => {
        this.onOffsetChange(0);
        this.onStateChange(RefreshState.Idle);
      });
    }
  }

  /**
   * 刷新完成后调用，重置状态
   */
  onRefreshDone(): void {
    this.onStateChange(RefreshState.Idle);
    this.onOffsetChange(0);
  }
}
