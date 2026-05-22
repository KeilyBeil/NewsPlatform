// TabBar.ets — 顶部新闻分类 Tab 导航栏组件

import NewsTypeModel from '../viewmodel/NewsData';
import newsViewModel from '../viewmodel/NewsViewModel';
import { CommonConstant as Const } from '../common/constant/CommonConstant';
import { NewsList } from './NewsList';

@Component
export default struct TabBar {
  @State currentIndex: number = 0;

  @State tabBarArray: NewsTypeModel[] = newsViewModel.getDefaultTypeList();

  aboutToAppear(): void {
    // 从服务器加载分类；失败时保留默认本地分类
    newsViewModel.getNewsTypeList().then((typeList: NewsTypeModel[]) => {
      this.tabBarArray = typeList;
    }).catch(() => {
      // 网络失败，继续使用默认分类，无需额外处理
      this.tabBarArray = Const.TabBars_DEFAULT_NEWS_TYPES;
    });
  }

  @Builder
  tabBarItem(item: NewsTypeModel, index: number) {
    Column() {
      Text(item.name as string)
        .fontSize(this.currentIndex === index ? 16 : 14)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === index ? $r('app.color.tab_selected_color') : $r('app.color.tab_normal_color'))
        .padding({ left: 12, right: 12 })

      Divider()
        .strokeWidth(2)
        .color($r('app.color.tab_selected_color'))
        .opacity(this.currentIndex === index ? 1 : 0)
        .margin({ top: 4 })
    }
    .height(Const.TAB_BAR_HEIGHT)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Tabs({ barPosition: BarPosition.Start }) {

      ForEach(this.tabBarArray, (tabItem: NewsTypeModel, index: number) => {

        TabContent() {
          NewsList({ typeId: tabItem.id })
        }
        .tabBar(this.tabBarItem(tabItem, index))

      })

    }
    .barMode(BarMode.Scrollable)
    .barWidth('100%')
    .barHeight(Const.TAB_BAR_HEIGHT)
    .animationDuration(300)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }
}
