moment.tz.setDefault('UTC');

$(document).ready(function() {
  $('[data-toggle="tooltip"]').each(function() {
    const el = $(this);
    el.tooltipster({
      contentAsHTML: true,
      interactive: true,
      trigger: 'hover',
      arrow: false,
      theme: 'tooltipster-hubble',
      side: el.data('tooltip-side') || 'bottom',
      viewportAware: true,
      animationDuration: 100,
      delay: [0, 600],
      functionBefore: function(instance, helper) {
        $.each($.tooltipster.instances(), function(i, instance) {
          instance.close();
        });
      }
    });
  });
});
