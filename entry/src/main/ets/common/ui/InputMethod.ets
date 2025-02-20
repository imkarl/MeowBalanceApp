import inputMethod from '@ohos.inputMethod';
import Log from '../utils/Log';

export default class InputMethod {

  static showSoftKeyboard() {
    try {
      let inputMethodController = inputMethod.getController();
      inputMethodController.showSoftKeyboard().then(() => {
        //console.log('Succeeded in hiding softKeyboard.');
      }).catch((err: object) => {
        //console.error('Failed to hideSoftKeyboard: ' + JSON.stringify(err));
      });
    } catch (throwable) {
      //Log.error("hideSoftKeyboard error, reason: "+JSON.stringify(throwable))
    }
  }

  static hideSoftKeyboard() {
    try {
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession().then(() => {
        //console.log('Succeeded in hiding softKeyboard.');
      }).catch((err: object) => {
        //console.error('Failed to hideSoftKeyboard: ' + JSON.stringify(err));
      });
    } catch (throwable) {
      //Log.error("hideSoftKeyboard error, reason: "+JSON.stringify(throwable))
    }
  }

}
