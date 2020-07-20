require "indexer/resources/cycle"

class TezosMailer < ApplicationMailer
  def cycle_report
    @user  = params[:user]
    @cycle_number = params[:cycle_number]
    @cycle = Indexer::Cycle.retrieve(@cycle_number)

    mail(to: @user.email, subject: "BakerHub: Cycle Report for Tezos Cycle #{@cycle_number}")
  end
end
