import { promptAction } from '@kit.ArkUI';

/**
 * Prompt util
 */
class PromptUtil {
  PROMPT_DURATION: number = 2000;

  /**
   * A dialog box is displayed.
   * @param message
   * @param time
   * @param bottom
   */
  promptMessage(message: string | Resource, time: number = this.PROMPT_DURATION, bottom: string | number = '80vp') {
    promptAction.showToast({
      message:message,
      duration: time,
      bottom: bottom
    })
  }
}

export default new PromptUtil();