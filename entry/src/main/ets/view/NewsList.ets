// NewsList.ets — 新闻列表组件（含下拉刷新 + 上拉加载更多）

import { NewsData } from '../viewmodel/NewsData';
import newsViewModel from '../viewmodel/NewsViewModel';
import { CommonConstant as Const } from '../common/constant/CommonConstant';
import { Logger } from '../common/utils/Logger';
import { NewsItem } from './NewsItem';
import { RefreshLayout, RefreshState } from './RefreshLayout';
import { LoadMoreLayout, LoadMoreState } from './LoadMoreLayout';

@Component
export struct NewsList {

  /** 当前新闻分类 ID（由父组件 TabBar 传入） */
  @Prop typeId: number = 0;

  /** 新闻数据列表 */
  @State newsList: NewsData[] = [];

  /** 当前页码 */
  @State currentPage: number = Const.FIRST_PAGE;

  /** 是否正在加载（节流用） */
  @State isLoading: boolean = false;

  /** 下拉刷新状态 */
  @State refreshState: RefreshState = RefreshState.Idle;

  /** 下拉偏移量（vp） */
  @State pullOffset: number = 0;

  /** 上拉加载状态 */
  @State loadMoreState: LoadMoreState = LoadMoreState.Idle;

  /** 是否还有更多数据 */
  private hasMore: boolean = true;

  /** 触摸起始 Y 坐标 */
  private touchStartY: number = 0;

  /** 列表是否处于顶部 */
  private isAtTop: boolean = true;

  /** ScrollController，用于监听滚动位置 */
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.loadFirstPage();
  }

  /**
   * 加载第一页数据（刷新时调用）
   */
  private loadFirstPage(): void {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;
    this.currentPage = Const.FIRST_PAGE;
    this.hasMore = true;

    newsViewModel.getNewsList(this.currentPage, Const.PAGE_SIZE, this.typeId)
      .then((data: NewsData[]) => {
        this.newsList = data;
        this.hasMore = data.length >= Const.PAGE_SIZE;
        this.refreshState = RefreshState.Idle;
        this.pullOffset = 0;
        this.loadMoreState = LoadMoreState.Idle;
        Logger.info('NewsList', '第一页加载成功，共%{public}d条', `${data.length}`);
      })
      .catch((err: string) => {
        Logger.error('NewsList', '第一页加载失败：%{public}s', err);
        this.refreshState = RefreshState.Idle;
        this.pullOffset = 0;
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  /**
   * 加载下一页数据（上拉时调用）
   */
  private loadNextPage(): void {
    if (this.isLoading || !this.hasMore) {
      return;
    }
    this.isLoading = true;
    this.loadMoreState = LoadMoreState.Loading;
    this.currentPage += 1;

    newsViewModel.getNewsList(this.currentPage, Const.PAGE_SIZE, this.typeId)
      .then((data: NewsData[]) => {
        if (data.length > 0) {
          this.newsList = [...this.newsList, ...data];
        }
        this.hasMore = data.length >= Const.PAGE_SIZE;
        this.loadMoreState = this.hasMore ? LoadMoreState.Idle : LoadMoreState.NoMore;
        Logger.info('NewsList', '第%{public}d页加载成功，共%{public}d条',
          `${this.currentPage}`, `${data.length}`);
      })
      .catch((err: string) => {
        Logger.error('NewsList', '分页加载失败：%{public}s', err);
        this.currentPage -= 1; // 回滚页码
        this.loadMoreState = LoadMoreState.Idle;
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {

      List({ scroller: this.scroller }) {

        // 顶部刷新区域（通过 ListItem 撑开）
        ListItem() {
          RefreshLayout({
            refreshState: this.refreshState,
            pullOffset: this.pullOffset
          })
        }

        // 新闻列表
        ForEach(this.newsList, (item: NewsData) => {
          ListItem() {
            NewsItem({ newsItem: item })
          }
        })

        // 底部加载更多区域
        ListItem() {
          LoadMoreLayout({ loadMoreState: this.loadMoreState })
        }

      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.page_bg_color'))
      .divider({ strokeWidth: 0 })
      .scrollBar(BarState.Off)
      .onScrollIndex((start: number) => {
        this.isAtTop = start === 0;
      })
      .onScrollFrameBegin((offset: number) => {
        // 上拉到底部时触发加载更多
        if (offset > 0 && this.loadMoreState === LoadMoreState.Idle && this.hasMore) {
          const currentOffset = this.scroller.currentOffset();
          // 粗略判断是否接近底部
          if (currentOffset.yOffset > 0) {
            this.loadNextPage();
          }
        }
        return { offsetRemain: offset };
      })
      .gesture(
        PanGesture({ direction: PanDirection.Vertical })
          .onActionStart((event: GestureEvent) => {
            this.touchStartY = event.offsetY;
          })
          .onActionUpdate((event: GestureEvent) => {
            const dy = event.offsetY - this.touchStartY;
            // 仅在列表处于顶部时处理下拉
            if (dy > 0 && this.isAtTop) {
              // 带阻尼效果（偏移量为实际距离的 0.4 倍）
              this.pullOffset = dy * 0.4;
              if (this.pullOffset >= Const.PULL_DOWN_THRESHOLD) {
                this.refreshState = RefreshState.ReadyToRelease;
              } else {
                this.refreshState = RefreshState.Pulling;
              }
            }
          })
          .onActionEnd(() => {
            if (this.refreshState === RefreshState.ReadyToRelease) {
              this.refreshState = RefreshState.Refreshing;
              this.loadFirstPage();
            } else {
              // 未达阈值，回弹
              animateTo({ duration: 200, curve: Curve.EaseOut }, () => {
                this.pullOffset = 0;
                this.refreshState = RefreshState.Idle;
              });
            }
          })
      )

      // 空数据占位（加载完成且列表为空）
      if (!this.isLoading && this.newsList.length === 0) {
        Column() {
          Text('📭')
            .fontSize(48)
            .opacity(0.4)
          Text('暂无新闻数据')
            .fontSize(14)
            .fontColor($r('app.color.news_source_color'))
            .margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .margin({ top: '30%' })
      }

      // 初次加载时全屏 Loading
      if (this.isLoading && this.newsList.length === 0) {
        Column() {
          LoadingProgress()
            .width(40)
            .height(40)
            .color($r('app.color.refresh_icon_color'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor($r('app.color.page_bg_color'))
      }

    }
    .width('100%')
    .height('100%')
  }
}
