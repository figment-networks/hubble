(function() {
  let perPage = 2;

  function genTables() {
    const tables = document.querySelectorAll('.table-pagination');
    for (let i = 0; i < tables.length; i++) {
      perPage = parseInt(tables[i].dataset.pagecount);
      createFooters(tables[i]);
      createTableMeta(tables[i]);
      loadTable(tables[i]);
    }
  }

  function loadTable(table) {
    let startIndex = 0;

    if (table.querySelector('th')) startIndex = 1;
    const start = (parseInt(table.dataset.currentpage) * table.dataset.pagecount) + startIndex;
    const end = start + parseInt(table.dataset.pagecount);
    const rows = table.rows;

    for (let x = startIndex; x < rows.length; x++) {
      if (x < start || x >= end) {
        rows[x].classList.add('inactive');
      } else {
        rows[x].classList.remove('inactive');
      }
    }
  }

  function createTableMeta(table) {
    table.dataset.currentpage = '0';
  }

  function createFooters(table) {
    let hasHeader = false;
    if (table.querySelector('th')) hasHeader = true;

    let rows = table.rows.length;

    if (hasHeader) rows = rows - 1;

    let numPages = rows / perPage;
    const pager = document.createElement('div');

    if (numPages % 1 > 0) {
      numPages = Math.floor(numPages) + 1;
    }

    pager.className = 'pager';

    for (let i = 0; i < numPages; i++) {
      const page = document.createElement('button');
      page.innerHTML = i + 1;
      page.className = 'pager__button';
      page.dataset.index = i;

      if (i == 0) page.classList.add('selected');

      page.addEventListener('click', function() {
        const parent = this.parentNode;
        const items = parent.querySelectorAll('.pager__button');
        for (let x = 0; x < items.length; x++) {
          items[x].classList.remove('selected');
        }
        this.classList.add('selected');
        table.dataset.currentpage = this.dataset.index;
        loadTable(table);
      });
      pager.appendChild(page);
    }

    table.nextElementSibling.appendChild(pager);
  }

  window.addEventListener('load', function() {
    genTables();
  });
})();
