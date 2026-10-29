// @ts-check

import { Notif } from "./notif.js";
/** @import { NotifOptions } from "./notif.js" */

/** A one-off hint, shown once per user and dismissed by clicking it. */
export class Tip extends Notif {
  static className = "_notif _notif-tip";

  /** @type {NotifOptions} */
  static defaultOptions = { autoHide: false };

  /** @inheritdoc */
  render() {
    this.html(this.tmpl(`tip${this.type}`));
  }
}
