Utils = {};
Utils.datepickerOptions = {
  useCurrent: false,
  icons: {
    time: 'mdi mdi-clock',
    date: 'mdi mdi-calendar',
    up: 'mdi mdi-chevron-up',
    down: 'mdi mdi-chevron-down',
    previous: 'mdi mdi-chevron-left',
    next: 'mdi mdi-chevron-right',
    today: 'mdi mdi-screenshot',
    clear: 'mdi mdi-trash',
    close: 'mdi mdi-remove'
  },
  format: 'DD/MM/YYYY'
};
Utils.autoNumericOptions = {
  aSep: ',',
  aDec: '.',
  aForm: false,
  mDec: '0',
  dGroup: 2
};
Utils.daterangepickerOptions = {
  opens: "left",
  parentEl: "body",
  autoUpdateInput: false,
  locale: {
    format: 'DD/MM/YYYY'
  },
  ranges: {
    'today': [moment(), moment()],
    'yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
    'tomorrow': [moment().add(1, 'days'), moment().add(1, 'days')],
    'last week': [moment().subtract(1, 'week').startOf("week"), moment().subtract(1, 'week').endOf("week")],
    'this week': [moment().startOf("week"), moment().endOf("week")],
    'last month': [moment().subtract(29, 'days'), moment()],
    'this month': [moment().startOf('month'), moment().endOf('month')]
  }

};
Utils.datetimepickerOptions = {
  useCurrent: false,
  icons: {
    time: 'mdi mdi-clock',
    date: 'mdi mdi-calendar',
    up: 'mdi mdi-chevron-up',
    down: 'mdi mdi-chevron-down',
    previous: 'mdi mdi-chevron-left',
    next: 'mdi mdi-chevron-right',
    today: 'mdi mdi-screenshot',
    clear: 'mdi mdi-trash',
    close: 'mdi mdi-remove'
  },
  format: 'DD/MM/YYYY h:mm A'
};
