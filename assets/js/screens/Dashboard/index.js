import Dropdown from '../../components/Dropdown';

const SELECTOR = {
  screen: 'body.dashboard',
  uploadReportButton: '.upload-report .form-report__button'
};

class DashboardScreen {
  /**
   * Initializer
   */
  constructor() {
    this.uploadReportButton = document.querySelector(SELECTOR.uploadReportButton);

    this._setup();
  }

  /**
   * Component bootstrapping actions.
   */
  _setup() {
    this.uploadDropdown = new Dropdown(this.uploadReportButton);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const isDashboardScreen = document.querySelector(SELECTOR.screen) !== null;

  if (isDashboardScreen) {
    new DashboardScreen();
  }
});
