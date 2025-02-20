import promptAction from '@ohos.promptAction';
import Log from '../utils/Log';

function toast(message: string | Resource, duration?: number) {
  try {
    promptAction.showToast({
      message: message,
      duration: duration==null ? 2000 : duration,
    });
  } catch (error) {
    Log.error(`showToast args error code is ${error.code}, message is ${error.message}`);
  };
}

export function toastError(error: ESObject, duration?: number) {
  if (typeof error == 'string') {
    toast(error, duration)
  } else if (typeof error == 'object') {
    toast(error, duration)
  } else {
    toast(JSON.stringify(error), duration)
  }
}

export default toast;
