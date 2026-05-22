// NewsItem.ets — 单条新闻列表项组件

import { NewsData, NewsFile } from '../viewmodel/NewsData';
import { CommonConstant as Const } from '../common/constant/CommonConstant';

/**
 * 单条新闻列表项：
 *  - 有图：左侧文字（标题 + 摘要 + 来源），右侧单张封面图
 *  - 无图：纯文字布局
 */
@Component
export struct NewsItem {

  /** 新闻数据 */
  newsItem: NewsData = new NewsData();

  /**
   * 获取第一张封面图的完整 URL
   */
  private getCoverUrl(): string {
    if (this.newsItem.imagesUrl && this.newsItem.imagesUrl.length > 0) {
      const firstImage: NewsFile = this.newsItem.imagesUrl[0];
      if (firstImage.url) {
        // 如果 url 已包含 http，直接返回；否则拼接服务器地址
        return firstImage.url.startsWith('http')
          ? firstImage.url
          : `${Const.SERVER}/${firstImage.url}`;
      }
    }
    return '';
  }

  private hasCover(): boolean {
    return this.getCoverUrl().length > 0;
  }

  @Builder
  coverImage() {
    Image(this.getCoverUrl())
      .width(100)
      .height(75)
      .borderRadius(6)
      .objectFit(ImageFit.Cover)
      .backgroundColor($r('app.color.image_placeholder_color'))
      .margin({ left: 12 })
  }

  build() {
    Column() {

      Row() {

        // 左侧：文字信息区
        Column() {

          // 标题
          Text(this.newsItem.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.news_title_color'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .lineHeight(22)
            .margin({ bottom: 6 })
            .width('100%')

          // 摘要（内容）
          if (this.newsItem.content) {
            Text(this.newsItem.content)
              .fontSize(13)
              .fontColor($r('app.color.news_content_color'))
              .maxLines(this.hasCover() ? 2 : 3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .lineHeight(19)
              .margin({ bottom: 8 })
              .width('100%')
          }

          // 来源
          Text(this.newsItem.source)
            .fontSize(12)
            .fontColor($r('app.color.news_source_color'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)

        // 右侧：封面图（有图才显示）
        if (this.hasCover()) {
          this.coverImage()
        }

      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .padding({ left: 16, right: 16, top: 14, bottom: 14 })

      // 底部分割线
      Divider()
        .strokeWidth(0.5)
        .color($r('app.color.divider_color'))
        .margin({ left: 16, right: 16 })

    }
    .width('100%')
    .backgroundColor($r('app.color.news_item_bg'))
  }
}
