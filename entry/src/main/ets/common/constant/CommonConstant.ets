// CommonConstant.ets — 全局常量定义

import NewsTypeModel from '../../viewmodel/NewsData';

export class CommonConstant {

  /** 服务器基础地址（开发环境） */
  static readonly SERVER: string = 'http://10.255.27.29:9588';

  /** 获取新闻分类接口路径 */
  static readonly GET_NEWS_TYPE: string = 'news/getNewsType';

  /** 获取新闻列表接口路径 */
  static readonly GET_NEWS_LIST: string = 'news/getNewsList';

  /** 每页新闻条数 */
  static readonly PAGE_SIZE: number = 4;

  /** HTTP 读取超时时间（毫秒） */
  static readonly HTTP_READ_TIMEOUT: number = 10000;

  /** HTTP 连接超时时间（毫秒） */
  static readonly HTTP_CONNECT_TIMEOUT: number = 10000;

  /** HTTP 成功状态码 */
  static readonly HTTP_CODE_200: number = 200;

  /** 业务层成功码 */
  static readonly SERVER_CODE_SUCCESS: string = '0';

  /** 下拉刷新触发阈值（vp） */
  static readonly PULL_DOWN_THRESHOLD: number = 64;

  /** 上拉加载触发阈值（vp） */
  static readonly PULL_UP_THRESHOLD: number = 64;

  /** 刷新区域高度（vp） */
  static readonly REFRESH_HEIGHT: number = 64;

  /** 加载更多区域高度（vp） */
  static readonly LOAD_MORE_HEIGHT: number = 56;

  /** 新闻列表首页页码 */
  static readonly FIRST_PAGE: number = 1;

  /** Tab 栏高度（vp） */
  static readonly TAB_BAR_HEIGHT: number = 48;

  /** 默认新闻分类列表（网络失败时使用） */
  static readonly TabBars_DEFAULT_NEWS_TYPES: NewsTypeModel[] = (() => {
    const all = new NewsTypeModel();
    all.id = 0;
    all.name = '全部';
    const domestic = new NewsTypeModel();
    domestic.id = 1;
    domestic.name = '国内';
    const international = new NewsTypeModel();
    international.id = 2;
    international.name = '国际';
    const society = new NewsTypeModel();
    society.id = 3;
    society.name = '社会';
    const tech = new NewsTypeModel();
    tech.id = 4;
    tech.name = '科技';
    const sports = new NewsTypeModel();
    sports.id = 5;
    sports.name = '体育';
    const entertainment = new NewsTypeModel();
    entertainment.id = 6;
    entertainment.name = '娱乐';
    return [all, domestic, international, society, tech, sports, entertainment];
  })();
}
