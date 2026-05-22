// NewsViewModel.ets — 新闻业务逻辑层（网络请求 + 数据转换）

import { httpRequestGet } from '../common/utils/HttpUtil';
import { CommonConstant as Const } from '../common/constant/CommonConstant';
import { Logger } from '../common/utils/Logger';
import NewsTypeModel, { NewsData } from './NewsData';

export class NewsViewModel {

  /**
   * 获取默认新闻分类列表（本地静态数据，网络失败时回退使用）
   */
  getDefaultTypeList(): NewsTypeModel[] {
    return Const.TabBars_DEFAULT_NEWS_TYPES;
  }

  /**
   * 从服务器获取新闻分类列表
   * 成功则 resolve(NewsTypeModel[])，失败则 reject(默认分类数组)
   */
  getNewsTypeList(): Promise<NewsTypeModel[]> {

    return new Promise((resolve, reject) => {

      const url = `${Const.SERVER}/${Const.GET_NEWS_TYPE}`;

      httpRequestGet(url).then((data) => {

        if (data.code === Const.SERVER_CODE_SUCCESS) {

          const typeList = data.data as NewsTypeModel[];
          Logger.info('NewsViewModel', '分类获取成功，共 %{public}d 项', `${typeList.length}`);
          resolve(typeList);

        } else {

          Logger.warn('NewsViewModel', '分类接口返回非成功码：%{public}s', data.code);
          reject(Const.TabBars_DEFAULT_NEWS_TYPES);

        }

      }).catch((err: Error) => {

        Logger.error('NewsViewModel', '分类请求失败：%{public}s', err.message ?? '');
        reject(Const.TabBars_DEFAULT_NEWS_TYPES);

      });

    });

  }

  /**
   * 从服务器获取新闻列表（分页）
   * @param currentPage 当前页码（从 1 开始）
   * @param pageSize    每页条数
   * @param typeId      分类 ID（0 = 全部）
   */
  getNewsList(currentPage: number, pageSize: number, typeId: number = 0): Promise<NewsData[]> {

    return new Promise((resolve, reject) => {

      const url = `${Const.SERVER}/${Const.GET_NEWS_LIST}?currentPage=${currentPage}&pageSize=${pageSize}&typeId=${typeId}`;

      httpRequestGet(url).then((data) => {

        if (data.code === Const.SERVER_CODE_SUCCESS) {

          const newsList = data.data as NewsData[];
          Logger.info('NewsViewModel', '新闻列表获取成功，第%{public}d页，共%{public}d条',
            `${currentPage}`, `${newsList.length}`);
          resolve(newsList);

        } else {

          Logger.warn('NewsViewModel', '新闻列表接口返回非成功码：%{public}s', data.code);
          reject('数据获取失败');

        }

      }).catch((err: Error) => {

        Logger.error('NewsViewModel', '新闻列表请求失败：%{public}s', err.message ?? '');
        reject('网络异常');

      });

    });

  }

}

/** 全局单例，供各组件直接使用 */
const newsViewModel = new NewsViewModel();
export default newsViewModel;
