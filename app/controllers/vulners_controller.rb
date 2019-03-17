class VulnersController < ApplicationController
  def start_integration
    start_time = Time.now
    VulnersService.start_integration

    log_execution_time(start_time)
  end

  private

  def log_execution_time(start_time)
    diff_time = (Time.now - start_time).to_i

    if diff_time > 60
      time_units = 'minutes'
      diff_time /= 60
    else
      time_units = 'seconds'
    end

    logger.info "stream request complete - it takes #{diff_time} #{time_units}"
  end
end
