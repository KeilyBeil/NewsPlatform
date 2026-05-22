// ResponseResult.ets — HTTP 响应结果封装类

/**
 * 服务端统一响应结构：
 * {
 *   "code": "0",      // 业务状态码，"0" 表示成功
 *   "msg": "success", // 提示信息
 *   "data": [...]     // 实际数据，类型由调用方确定
 * }
 */
export class ResponseResult {

  /** 业务状态码（"0" 为成功） */
  code: string = '';

  /** 提示消息 */
  msg: string = '';

  /** 实际响应数据（泛型，由解析方自行转换） */
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  data: object | string | null = null;

}
