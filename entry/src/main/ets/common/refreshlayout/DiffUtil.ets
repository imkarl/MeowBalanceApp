import ArrayList from '@ohos.util.ArrayList';


export enum OperationType { Add, Remove, Move, Update };
class Operation {
  type: OperationType;
  from: number;
  to: number;

  constructor(type: OperationType, from: number, to: number) {
    this.type = type;
    this.from = from;
    this.to = to;
  }
}


export default class DiffUtil {

  static diffList<T>(oldList: ArrayList<T>, newList: ArrayList<T>, ): Operation[] {
    const operations: Operation[] = [];

    if (oldList && oldList.length > 0) {
      oldList.forEach((_item, index: number) => operations.push(new Operation(OperationType.Remove, index, index)))
    }
    if (newList && newList.length > 0) {
      newList.forEach((_item, index: number) => operations.push(new Operation(OperationType.Add, index, index)))
    }

    return operations;
  }

  static diffList2<T>(oldList: ArrayList<T>, newList: ArrayList<T>, ): Operation[] {
    const operations: Operation[] = [];

    if (newList.length === 0) {
      newList.forEach((_item, index: number) => operations.push(new Operation(OperationType.Add, index, index)))
      return operations.reverse();
    }

    if (newList.length === 0) {
      oldList.forEach((_item, index: number) => operations.push(new Operation(OperationType.Remove, index, index)))
      return operations.reverse();
    }

    if (oldList.length <= newList.length) {
      newList.forEach((_item, index: number) => {
        if (!index) {
          return
        }
        if (index < oldList.length) {
          operations.push(new Operation(OperationType.Update, index, index))
        } else {
          operations.push(new Operation(OperationType.Add, index, index))
        }
      })
    }

    if (oldList.length > newList.length) {
      oldList.forEach((_item, index: number) => {
        if (index < newList.length) {
          operations.push(new Operation(OperationType.Update, index, index))
        } else {
          operations.push(new Operation(OperationType.Remove, index, index))
        }
      })
    }

    return operations.reverse();
  }

}