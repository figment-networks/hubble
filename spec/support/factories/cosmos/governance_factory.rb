FactoryBot.define do
  factory :cosmos_governance_proposal, class: 'Cosmos::Governance::Proposal' do
    ext_id { 27 }
    title { 'Stargate Upgrade Proposal 1' }
    description do
      'Stargate is our name for the process of ensuring that the widely integrated public network known as the Cosmos Hub is able to execute the cosmoshub-3 -> cosmoshub-4 upgrade with the minimum disruption to its existing ecosystem. This upgrade will also realize the Internet of Blockchains vision from the Cosmos whitepaper.
        Integrations from ecosystem partners are at risk of breaking changes due to the Stargate changes. These changes drive the need for substantial resource and time requirements to ensure successful migration. Stargate represents a unique set of circumstances and is not intended to set precedent for future upgrades which are expected to be less dramatic.
          There is a widespread consensus from many Cosmos stakeholders that these changes to core software components will enhance the performance and composability of the software and the value of the Cosmos Hub in a world of many blockchains.
          A Yes result on this proposal provides a clear signal that the Cosmos Hub accepts and understands the Stargate process and is prepared to approve an upgrade with proposed changes if the plan below is executed successfully.
          A No result would force a reconsideration of the tradeoffs in the Alternatives section and the forming a new plan to deliver IBC.
          See the full proposal here: https://ipfs.io/ipfs/Qmbo3fF54tX3JdoHZNVLcSBrdkXLie56Vh2u29wLfs4PnW'
    end
    proposal_type { 'cosmos-sdk/TextProposal' }
    proposal_status { 'VotingPeriod' }
    tally_result_yes { 85986459559457 }
    tally_result_abstain { 535408864 }
    tally_result_no { 21169926706 }
    tally_result_nowithveto { 106144492 }
    submit_time { '2020-07-12 06:23:02.440964' }
    total_deposit { [{ 'denom': 'uatom', 'amount': '512000000' }] }
    voting_start_time { '2020-07-13 01:37:47.298505' }
    voting_end_time { '2020-07-27 01:37:47.298505' }
    created_at { '2020-07-23 15:40:21.978086' }
    updated_at { '2020-07-23 15:40:25.969945' }
    deposit_end_time { '2020-07-26 06:23:02.440964' }
    additional_data { {} }
    finalized { false }
  end
end
