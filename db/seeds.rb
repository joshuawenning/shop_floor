# Frozen_string_literal: true

# A representative aerospace production program. Records are keyed by their
# controlled identifiers so this file can be run repeatedly.

parts_data = [
  { number: "AVX-FCC-4400", name: "Flight Control Computer", revision: "D", inventory_quantity: 6 },
  { number: "CAB-HAR-0098", name: "Avionics Data Harness", revision: "H", inventory_quantity: 35 },
  { number: "ENV-HST-6100", name: "Heat Shield Tile Array", revision: "C", inventory_quantity: 28 },
  { number: "FS-STA-2101", name: "Flight Control Servo Actuator", revision: "F", inventory_quantity: 18 },
  { number: "HYD-MNF-5000", name: "Hydraulic Manifold Assembly", revision: "D", inventory_quantity: 14 },
  { number: "LGS-TRN-3200", name: "Main Landing Gear Trunnion", revision: "E", inventory_quantity: 4 },
  { number: "PWR-PDU-270V", name: "Power Distribution Unit, 270 VDC", revision: "G", inventory_quantity: 11 },
  { number: "PRP-TBV-1800", name: "Cryogenic Turbopump Valve", revision: "B", inventory_quantity: 9 },
  { number: "SNS-IMU-3300", name: "Inertial Measurement Unit", revision: "E", inventory_quantity: 7 },
  { number: "STR-RIB-7075", name: "Wing Spar Rib, LH", revision: "C", inventory_quantity: 42 }
]

work_orders_data = [
  {
    number: "WO-AS-26011",
    part_number: "AVX-FCC-4400",
    quantity: 8,
    due_on: 8.days.ago.to_date,
    status: :completed,
    notes: "Lot acceptance complete. Configuration baseline FC-4D released to final stores.",
    operations: [
      { name: "SMT assembly", position: 1, status: :completed },
      { name: "Conformal coating", position: 2, status: :completed },
      { name: "Automated optical inspection", position: 3, status: :completed },
      { name: "Hardware-in-the-loop test", position: 4, status: :completed },
      { name: "Configuration verification", position: 5, status: :completed }
    ]
  },
  {
    number: "WO-AS-26012",
    part_number: "HYD-MNF-5000",
    quantity: 12,
    due_on: 4.days.ago.to_date,
    status: :completed,
    notes: "Pressure test witnessed by quality. Material and process certifications archived.",
    operations: [
      { name: "Five-axis machining", position: 1, status: :completed },
      { name: "Fluorescent penetrant inspection", position: 2, status: :completed },
      { name: "Passivation", position: 3, status: :completed },
      { name: "Proof pressure test", position: 4, status: :completed },
      { name: "Final dimensional inspection", position: 5, status: :completed }
    ]
  },
  {
    number: "WO-AS-26017",
    part_number: "FS-STA-2101",
    quantity: 24,
    due_on: 2.days.from_now.to_date,
    status: :active,
    notes: "Flight shipset 03. Maintain matched gear sets through assembly and test.",
    operations: [
      { name: "Gear train inspection", position: 1, status: :completed },
      { name: "Actuator mechanical assembly", position: 2, status: :completed },
      { name: "Resolver alignment", position: 3, status: :in_progress },
      { name: "Environmental stress screening", position: 4, status: :pending },
      { name: "Acceptance test procedure", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-AS-26018",
    part_number: "STR-RIB-7075",
    quantity: 36,
    due_on: 2.days.ago.to_date,
    status: :active,
    notes: "Recovery plan active. CMM capacity added on second shift to clear inspection hold point.",
    operations: [
      { name: "Material certification review", position: 1, status: :completed },
      { name: "High-speed machining", position: 2, status: :completed },
      { name: "Deburr and edge break", position: 3, status: :completed },
      { name: "Coordinate measurement inspection", position: 4, status: :in_progress },
      { name: "Primer application", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-AS-26019",
    part_number: "PRP-TBV-1800",
    quantity: 16,
    due_on: 6.days.from_now.to_date,
    status: :active,
    notes: "Clean-room assembly required. Preserve oxygen-clean certification after final test.",
    operations: [
      { name: "Valve body machining", position: 1, status: :completed },
      { name: "Electropolish and clean", position: 2, status: :completed },
      { name: "Clean-room assembly", position: 3, status: :in_progress },
      { name: "Cryogenic leak test", position: 4, status: :pending },
      { name: "Flow calibration", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-AS-26020",
    part_number: "CAB-HAR-0098",
    quantity: 40,
    due_on: 4.days.from_now.to_date,
    status: :active,
    notes: "Route per installation drawing 0098-H. Record pull-test values by operator and cavity.",
    operations: [
      { name: "Wire cut and laser mark", position: 1, status: :completed },
      { name: "Contact crimp and pull test", position: 2, status: :in_progress },
      { name: "Connector assembly", position: 3, status: :pending },
      { name: "Continuity and hipot test", position: 4, status: :pending },
      { name: "Form-board inspection", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-AS-26021",
    part_number: "LGS-TRN-3200",
    quantity: 6,
    due_on: 9.days.from_now.to_date,
    status: :scheduled,
    notes: "First article unit included. Source inspection required before shot peen release.",
    operations: [
      { name: "Forging receipt inspection", position: 1, status: :pending },
      { name: "Rough machining", position: 2, status: :pending },
      { name: "Ultrasonic inspection", position: 3, status: :pending },
      { name: "Finish machining", position: 4, status: :pending },
      { name: "Shot peen and cadmium plate", position: 5, status: :pending },
      { name: "First article inspection", position: 6, status: :pending }
    ]
  },
  {
    number: "WO-AS-26022",
    part_number: "SNS-IMU-3300",
    quantity: 10,
    due_on: 14.days.from_now.to_date,
    status: :scheduled,
    notes: "Calibration profile LEO-7. Thermal-vacuum chamber slot reserved for next cycle.",
    operations: [
      { name: "Sensor stack assembly", position: 1, status: :pending },
      { name: "Precision alignment", position: 2, status: :pending },
      { name: "Firmware load", position: 3, status: :pending },
      { name: "Thermal-vacuum calibration", position: 4, status: :pending },
      { name: "Navigation solution verification", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-AS-26023",
    part_number: "ENV-HST-6100",
    quantity: 48,
    due_on: 18.days.from_now.to_date,
    status: :scheduled,
    notes: "Handle with contamination controls. Bond-line thickness is a key characteristic.",
    operations: [
      { name: "Tile contour machining", position: 1, status: :pending },
      { name: "Density inspection", position: 2, status: :pending },
      { name: "Waterproofing treatment", position: 3, status: :pending },
      { name: "Strain isolation pad bond", position: 4, status: :pending },
      { name: "Bond proof test", position: 5, status: :pending }
    ]
  },
  {
    number: "WO-AS-26024",
    part_number: "PWR-PDU-270V",
    quantity: 10,
    due_on: 11.days.from_now.to_date,
    status: :cancelled,
    notes: "Cancelled pending incorporation of engineering change order ECO-270-118.",
    operations: [
      { name: "Chassis preparation", position: 1, status: :pending },
      { name: "Power board installation", position: 2, status: :pending },
      { name: "Harness integration", position: 3, status: :pending },
      { name: "Dielectric withstand test", position: 4, status: :pending }
    ]
  }
]

ActiveRecord::Base.transaction do
  parts = parts_data.each_with_object({}) do |attributes, seeded_parts|
    part = Part.find_or_initialize_by(number: attributes[:number])
    part.update!(attributes)
    seeded_parts[part.number] = part
  end

  work_orders_data.each do |attributes|
    operations = attributes.fetch(:operations)
    status = attributes.fetch(:status)
    work_order = WorkOrder.find_or_initialize_by(number: attributes.fetch(:number))

    work_order.assign_attributes(
      due_on: attributes.fetch(:due_on),
      notes: attributes[:notes],
      part: parts.fetch(attributes.fetch(:part_number)),
      quantity: attributes.fetch(:quantity),
      status: :scheduled
    )
    work_order.save!

    work_order.operations.destroy_all
    operations.each { |operation| work_order.operations.create!(operation) }
    work_order.update!(status: status)
  end
end

puts "Seeded aerospace production data:"
puts "  #{Part.count} parts"
puts "  #{WorkOrder.count} work orders"
puts "  #{Operation.count} operations"
