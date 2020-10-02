moment.tz.setDefault('EST');

$(document).ready(function() {
  $('[data-toggle="tooltip"]').each(function() {
    const el = $(this);
    el.tooltipster({
      contentAsHTML: true,
      interactive: true,
      trigger: 'hover',
      arrow: false,
      theme: 'tooltipster-hubble',
      side: el.data('tooltip-side') || 'right',
      viewportAware: true,
      delay: 25
    });
  });
});
