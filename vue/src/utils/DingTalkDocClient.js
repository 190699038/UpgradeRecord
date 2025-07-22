import axios from 'axios';

class DingTalkDocClient {
  constructor(appKey, appSecret) {
    this.appKey = appKey;
    this.appSecret = appSecret;
    this.accessToken = null;
    this.tokenExpireTime = 0;
    this.baseURL = 'https://api.dingtalk.com';
  }

  // 1. 认证：获取并缓存Access Token
  async #authenticate() {
    // 检查Token有效期（提前5分钟刷新）
    if (this.accessToken && Date.now() < this.tokenExpireTime) return;

    try {
      const response = await axios.post(`${this.baseURL}/v1.0/oauth2/accessToken`, {
        appKey: this.appKey,
        appSecret: this.appSecret
      });
      
      this.accessToken = response.data.accessToken;
      this.tokenExpireTime = Date.now() + response.data.expiresIn * 1000 - 300000; // 提前5分钟刷新
    } catch (error) {
      const errMsg = error.response?.data?.message || error.message;
      throw new Error(`钉钉认证失败: ${errMsg}`);
    }
  }

  // 2. 读取文档内容
  async getDocument(docId) {
    try {
      await this.#authenticate(); // 确保Token有效
      
      const response = await axios.get(`${this.baseURL}/v1.0/doc/documents/${docId}`, {
        headers: { 'x-acs-dingtalk-access-token': this.accessToken }
      });
      return response.data; // 返回文档完整数据
    } catch (error) {
      const errMsg = error.response?.data?.message || error.message;
      throw new Error(`文档读取失败: ${errMsg}`);
    }
  }
}

// 初始化实例（使用用户提供的凭证）
export const dingTalkDocClient = new DingTalkDocClient(
  'dingzuppjje8doj1mqqm',
  '_e8KB_6fnl8Ze1pfvXS6DWy5-gVpdv_WMgtgZrFY5yric2JRiBELm6shgVx5O-r7'
);