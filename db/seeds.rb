# Frozen_string_literal: true

# Shop Floor seed data — idempotent, safe to run repeatedly.

parts = [
  { number: "PCB-4421", name: "Control Board Assembly", revision: "C", inventory_quantity: 12 },
  { number: "ENC-1040", name: "Aluminum Enclosure", revision: "B", inventory_quantity: 8 },
  { number: "INV-2200", name: "Inverter Housing", revision: "A", inventory_quantity: 5 },
  { number: "BRK-3100", name: "Motor Mount Bracket", revision: nil, inventory_quantity: 24 },
  { number: "SNS-2055", name: "Temperature Sensor", revision: "D", inventory_quantity: 50 },
  { number: "CAB-7800", name: "Control Wiring Harness", revision: nil, inventory_quantity: 18 },
  { number: "PWR-9010", name: "Power Supply Module", revision: "A", inventory_quantity: 30 },
  { number: "REL-6335", name: "Relay Board", revision: "B", inventory_quantity: 40 }
]

created_parts = parts.map do |attrs|
  Part.find_or_create_by!(number: attrs[:number]) do |p|
    p.name = attrs[:name]
    p.revision = attrs[:revision]
    p.inventory_quantity = attrs[:inventory_quantity]
  end
end

pcb, enclosure, inverter, bracket, sensor, harness, power_supply, relay = created_parts

# ── Work Orders ──────────────────────────────────────────────

work_orders_data = [
  # Completed — all operations done
  {
    number: "WO-2001", part: pcb, quantity: 50, due_on: 2.days.ago,
    status: :completed, notes: "Rush order for Q3 shipment",
    operations: [
      { name: "Solder paste application", position: 1, status: :completed },
      { name: "Component placement", position: 2, status: :completed },
      { name: "Reflow soldering", position: 3, status: :completed },
      { name: "AOI inspection", position: 4, status: :completed }
    ]
  },
  {
    number: "WO-2002", part: inverter, quantity: 20, due_on: 1.day.ago,
    status: :completed,
    operations: [
      { name: "CNC milling", position: 1, status: :completed },
      { name: "Anodize surface", position: 2, status: :completed },
      { name: "Final assembly", position: 3, status: :completed }
    ]
  },

  # Active — some operations in progress
  {
    number: "WO-2003", part: enclosure, quantity: 100, due_on: 3.days.from_now,
    status: :active, notes: "Priority order — new customer",
    operations: [
      { name: "Sheet metal cutting", position: 1, status: :completed },
      { name: "CNC bending", position: 2, status: :completed },
      { name: "Welding", position: 3, status: :in_progress },
      { name: "Powder coating", position: 4, status: :pending },
      { name: "Final QC", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-2004", part: harness, quantity: 200, due_on: 5.days.from_now,
    status: :active,
    operations: [
      { name: "Wire cutting", position: 1, status: :completed },
      { name: "Crimping", position: 2, status: :in_progress },
      { name: "Connector assembly", position: 3, status: :pending },
      { name: "Continuity test", position: 4, status: :pending }
    ]
  },

  # Scheduled — all operations pending
  {
    number: "WO-2005", part: bracket, quantity: 500, due_on: 7.days.from_now,
    status: :scheduled,
    operations: [
      { name: "Laser cutting", position: 1, status: :pending },
      { name: "CNC drilling", position: 2, status: :pending },
      { name: "Deburring", position: 3, status: :pending },
      { name: "Zinc plating", position: 4, status: :pending }
    ]
  },
  {
    number: "WO-2006", part: sensor, quantity: 300, due_on: 10.days.from_now,
    status: :scheduled, notes: "Long lead — sensor calibration kits on order",
    operations: [
      { name: "Die bonding", position: 1, status: :pending },
      { name: "Wire bonding", position: 2, status: :pending },
      { name: "Encapsulation", position: 3, status: :pending },
      { name: "Calibration", position: 4, status: :pending },
      { name: "Final QC", position: 5, status: :pending }
    ]
  },

  # Active — just started
  {
    number: "WO-2007", part: power_supply, quantity: 75, due_on: 4.days.from_now,
    status: :active,
    operations: [
      { name: "PCB population", position: 1, status: :in_progress },
      { name: "Through-hole soldering", position: 2, status: :pending },
      { name: "Load testing", position: 3, status: :pending },
      { name: "Burn-in", position: 4, status: :pending }
    ]
  },

  # Overdue active
  {
    number: "WO-2008", part: relay, quantity: 150, due_on: 2.days.ago,
    status: :active, notes: "Behind schedule — resource shortage",
    operations: [
      { name: "Coil winding", position: 1, status: :completed },
      { name: "Contact assembly", position: 2, status: :completed },
      { name: "Housing seal", position: 3, status: :in_progress },
      { name: "Functional test", position: 4, status: :pending }
    ]
  },

  # Cancelled
  {
    number: "WO-2009", part: pcb, quantity: 25, due_on: 1.day.ago,
    status: :cancelled, notes: "Cancelled — design revision pending",
    operations: [
      { name: "Solder paste application", position: 1, status: :pending },
      { name: "Component placement", position: 2, status: :pending },
      { name: "Reflow soldering", position: 3, status: :pending }
    ]
  },

  # Completed
  {
    number: "WO-2010", part: bracket, quantity: 300, due_on: 5.days.ago,
    status: :completed,
    operations: [
      { name: "Laser cutting", position: 1, status: :completed },
      { name: "CNC drilling", position: 2, status: :completed },
      { name: "Deburring", position: 3, status: :completed },
      { name: "Zinc plating", position: 4, status: :completed }
    ]
  }
]

work_orders_data.each do |wo_data|
  wo = WorkOrder.find_or_create_by!(number: wo_data[:number]) do |w|
    w.part = wo_data[:part]
    w.quantity = wo_data[:quantity]
    w.due_on = wo_data[:due_on]
    w.notes = wo_data[:notes]
  end

  wo_data[:operations].each do |op_data|
    existing = wo.operations.find_by(name: op_data[:name])
    unless existing
      op = wo.operations.build(
        name: op_data[:name],
        position: op_data[:position]
      )
      op.status = op_data[:status]
      op.save!
    end
  end

  # Set status after operations exist (so validation passes)
  unless wo.status == wo_data[:status]
    wo.update!(status: wo_data[:status])
  end
end

puts "Seeded #{Part.count} parts, #{WorkOrder.count} work orders, #{Operation.count} operations."
