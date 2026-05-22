// NewsData.ets（新闻条目数据模型）

export class NewsData {

  title: string = '';       // 新闻标题

  content: string = '';     // 新闻摘要

  imagesUrl: Array<NewsFile> = [new NewsFile()]; // 新闻图片列表（含URL）

  source: string = '';      // 新闻来源

}



export class NewsFile {

  url: string = '';         // 图片URL（需拼接服务器地址）

}

export default class NewsTypeModel {

  id: number = 0;           // 分类ID（如0:全部，1:国内）

  name: ResourceStr = '';   // 分类名称（如“国内”“国际”）

}