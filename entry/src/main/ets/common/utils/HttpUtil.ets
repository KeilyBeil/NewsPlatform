// HttpUtil.ets — 网络请求工具（封装 @kit.NetworkKit 的 HTTP GET）

import { http } from '@kit.NetworkKit';
import { CommonConstant as Const } from '../constant/CommonConstant';
import { ResponseResult } from '../../viewmodel/ResponseResult';
import { Logger } from './Logger';

/**
 * 发起 GET 请求，返回 Promise<ResponseResult>
 * @param url 完整请求地址
 */
export function httpRequestGet(url: string): Promise<ResponseResult> {

  const httpRequest = http.createHttp();

  return httpRequest.request(url, {

    method: http.RequestMethod.GET,

    readTimeout: Const.HTTP_READ_TIMEOUT,

    connectTimeout: Const.HTTP_CONNECT_TIMEOUT,

    header: { 'Content-Type': 'application/json' }

  }).then((value) => {

    const serverData = new ResponseResult();

    if (value.responseCode === Const.HTTP_CODE_200) {

      const resultJson = JSON.parse(`${value.result}`) as Record<string, string | object>;
      serverData.code = `${resultJson['code']}`;
      serverData.msg = `${resultJson['msg']}`;
      serverData.data = resultJson['data'] as object;

    } else {

      serverData.code = 'fail';
      serverData.msg = `HTTP错误：${value.responseCode}`;
      Logger.warn('HttpUtil', 'HTTP error, code=%{public}d', `${value.responseCode}`);

    }

    httpRequest.destroy();
    return serverData;

  }).catch((err: Error) => {

    Logger.error('HttpUtil', '网络请求失败：%{public}s，url=%{public}s', err.message ?? '未知错误', url);
    httpRequest.destroy();
    const failResult = new ResponseResult();
    failResult.code = 'fail';
    failResult.msg = err.message ?? '网络请求失败';
    failResult.data = null;
    return failResult;

  });

}
