module TransactionSearchHelper
  def prev_page
    params['page'].to_i > 1 ? params['page'].to_i - 1 : 1
  end

  def prev_page_disabled
    @prev_page ? '' : 'disabled'
  end

  def next_page
    params['page'].to_i > 0 ? params['page'].to_i + 1 : 2
  end

  def next_page_disabled
    @next_page ? '' : 'disabled'
  end

  def tx_search_show_opt_selected
    if params['search']
      return params['search']['show']
    end

    return ''
  end

  def selected_chain
    @search_form.chain_ids || params['chain_id']
  end
end
