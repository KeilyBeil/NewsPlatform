// NewsModel.ets — 新闻列表数据管理层（辅助 ViewModel 进行本地缓存或数据去重）

import { NewsData } from './NewsData';

/**
 * 新闻数据管理类，提供本地缓存能力：
 * - 对新旧数据合并时去重（按 title + source 去重）
 * - 清空缓存
 */
export class NewsModel {

  private cachedList: NewsData[] = [];

  /**
   * 获取当前缓存的新闻列表
   */
  getCachedList(): NewsData[] {
    return this.cachedList;
  }

  /**
   * 追加新数据并去重
   * @param newItems 新加载的新闻条目
   */
  appendAndDeduplicate(newItems: NewsData[]): NewsData[] {
    const existingKeys = new Set(
      this.cachedList.map((item: NewsData) => `${item.title}_${item.source}`)
    );
    const uniqueNew = newItems.filter((item: NewsData) =>
      !existingKeys.has(`${item.title}_${item.source}`)
    );
    this.cachedList = [...this.cachedList, ...uniqueNew];
    return this.cachedList;
  }

  /**
   * 重置（刷新时调用）
   * @param freshItems 刷新后的第一页数据
   */
  reset(freshItems: NewsData[]): NewsData[] {
    this.cachedList = [...freshItems];
    return this.cachedList;
  }

  /**
   * 清空缓存
   */
  clear(): void {
    this.cachedList = [];
  }
}
