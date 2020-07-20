class Kava::SyncBase < Cosmoslike::SyncBase
  def get_validator_set( height )
    # tendermint 0.33+ paginates /validators
    # but doesn't say how many pages or anything. so fine, we just
    # go ahead and keep asking for pages until there's no more results.
    # except if you ask for a page which has no results they _error instead_
    # so this is pretty ugly

    validators = []
    page = 1

    while true
      r = rpc_get( 'validators', height: height, page: page, per_page: 100 )

      if r.has_key?('result')
        new_validators = r['result']['validators']
        validators.concat(new_validators)

        # let's also handle the case where there's no results
        if new_validators.empty?
          break
        else
          page += 1
        end

      elsif r.has_key?('error') && r['error']['data'] =~ /page should be within/
        break

      else
        raise RuntimeError.new("Could not retrieve validator set at height #{height}. #{r}")

      end
    end

    validators
  end
end
