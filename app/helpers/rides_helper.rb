module RidesHelper
  def ride_status_badge(ride)
    klasses = { pending: 'warning', accepted: 'success', rejected: 'danger', completed: 'success', canceled: 'default' }
    klass = klasses.fetch(ride.status.to_sym, ride.status)

    content_tag(:span, t(ride.status, scope: 'ride.status'), class: "badge badge-#{klass}")
  end
end
