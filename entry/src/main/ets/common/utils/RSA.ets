import { buffer, util } from "@kit.ArkTS";
import { cryptoFramework } from "@kit.CryptoArchitectureKit";

export default class RSA {

  // 公钥字符串
  private static pubKeyStr = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDfma3C4cMV2Ogabp+qipYWr8+rqB6PFYrw9sKIcNCqzirmhBXtF2+q3if74DZ2S0uF7VQMVF00FJqLNd7BnkZqlFoHx+1KW7y8PGYLOeIzieSiAT3By+gfg4oyNqhtiMtuHrW5fQO0LuoSx/8ujR8c2HAOQCawt6mIV0488DexuwIDAQAB"
  private static pubkeyAlgName = "RSA1024"

  private static ENCRYPT_CIPHER = "RSA|ECB|PKCS1"

  static async encrypt(plaintext: string): Promise<string> {
    // 初始化Base64工具实例
    let base64Helper = new util.Base64Helper();
    // 公钥转换为Uint8Array，然后包装为DataBlob类型
    let pubKeyBlob: cryptoFramework.DataBlob = { data: base64Helper.decodeSync(RSA.pubKeyStr) };
    // 创建RSA key生成器
    let rsaGenerator = cryptoFramework.createAsyKeyGenerator(RSA.pubkeyAlgName);
    // 将公钥包装数据pubKeyBlob转换成密钥对类型KeyPair
    let keyPair = await rsaGenerator.convertKey(pubKeyBlob, null);
    // 创建 Cipher对象
    let cipher = cryptoFramework.createCipher(RSA.ENCRYPT_CIPHER);
    // 初始化加密模式，指定密钥keyPair.pubKey
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, keyPair.pubKey, null);
    // 包装要加密的明文
    let plainTextBlob: cryptoFramework.DataBlob = { data: new Uint8Array(buffer.from(plaintext, 'utf-8').buffer) };
    // 传入明文，获取加密后的数据
    let encryptBlob = await cipher.doFinal(plainTextBlob);
    // 返回加密后的字符串
    return await base64Helper.encodeToString(encryptBlob.data);
  }

}