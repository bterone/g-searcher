import { Dropdown as BootstrapDropdown } from '../../vendor/bootstrap';

class Dropdown {
  /**
   * Initialize
   */
  constructor(elementRef) {
    this.elementRef = elementRef;

    this._setup();
  }

  // Private

  /**
   * Component bootstrapping actions.
   */
  _setup() {
    this.dropdown = new BootstrapDropdown(this.elementRef, true);
  }
}

export default Dropdown;
