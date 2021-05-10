import { Dropdown } from '../vendor/bootstrap';

const SELECTOR = '[data-toggle="dropdown"]';

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll(SELECTOR).forEach((element) => {
    new Dropdown(element);
  });
});
