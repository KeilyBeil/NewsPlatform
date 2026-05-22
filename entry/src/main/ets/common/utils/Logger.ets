// Logger.ets — 日志工具类（基于 hilog 封装）

import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x1000; // 应用域标识
const TAG: string = 'NewsData'; // 默认日志 Tag

export class Logger {


  static debug(tag: string = TAG, format: string, ...args: string[]): void {
    hilog.debug(DOMAIN, tag, format, ...args);
  }


  static info(tag: string = TAG, format: string, ...args: string[]): void {
    hilog.info(DOMAIN, tag, format, ...args);
  }

  /**
   * 警告日志（WARN 级别）
   */
  static warn(tag: string = TAG, format: string, ...args: string[]): void {
    hilog.warn(DOMAIN, tag, format, ...args);
  }


  static error(tag: string = TAG, format: string, ...args: string[]): void {
    hilog.error(DOMAIN, tag, format, ...args);
  }

}
