class AppConstants {
  static const List<String> fuelTypes = ['Regular', 'Premium'];

  // Motor
  static const List<String> engineTypes = ['4T', '2T'];

  static const List<String> twoStrokeOilMethods = [
    'Inyección de aceite (autolube)',
    'Premezclado con gasolina',
    'Sin aceite separado',
  ];

  // Refrigeración
  static const List<String> coolingTypes = ['Aire', 'Líquido (radiador)'];

  // Aceites 4T
  static const List<String> oilTypes4T = [
    'Mineral',
    'Semi-sintético',
    'Sintético',
    '4T Genérico',
  ];

  // Aceites 2T (autolube)
  static const List<String> oilTypes2T = [
    '2T Mineral',
    '2T Semi-sintético',
    '2T Sintético',
    '2T Genérico',
  ];

  static List<String> get oilTypes => [...oilTypes4T, ...oilTypes2T];

  static const List<String> oilViscosities = [
    '10W-40',
    '20W-50',
    '15W-50',
    '10W-30',
    '5W-30',
    '5W-40',
    '0W-40',
  ];

  // Tipos de llanta
  static const List<Map<String, String>> tireTypes = [
    {'value': 'standard',  'label': '🛞 Estándar'},
    {'value': 'sealant',   'label': '💧 Antipinchazo / Slime'},
    {'value': 'tube',      'label': '🔵 Con cámara / Tripa'},
    {'value': 'tubeless',  'label': '⭕ Sin cámara (tubeless)'},
  ];

  // Tipos de rin — determina qué tipos de llanta son compatibles
  // spoke standard: solo cámara (tripa). Los nipples de los rayos no sellan el aro.
  // spoke_double_wall: pared interior sella los agujeros → admite tubeless y antipinchazo.
  // alloy: rin fundido sin agujeros → admite todos los tipos.
  static const List<Map<String, dynamic>> rimTypes = [
    {
      'value': 'alloy',
      'label': 'Paleta / Aleación',
      'emoji': '⭕',
      'desc': 'Rin fundido de aluminio en una pieza. Compatible con tubeless, antipinchazo y cámara.',
      'compatibleTireTypes': ['standard', 'tubeless', 'sealant', 'tube'],
    },
    {
      'value': 'spoke',
      'label': 'Rayos estándar',
      'emoji': '🔩',
      'desc': 'Los nipples crean agujeros en el aro, imposible sellar tubeless. Solo admite cámara (tripa).',
      'compatibleTireTypes': ['tube'],
    },
    {
      'value': 'spoke_double_wall',
      'label': 'Rayos doble pestaña',
      'emoji': '🛞',
      'desc': 'Pared interior sella los agujeros de los rayos. Compatible con tubeless y antipinchazo.',
      'compatibleTireTypes': ['standard', 'tubeless', 'sealant', 'tube'],
    },
  ];

  static List<String> compatibleTireTypes(String rimType) {
    final rim = rimTypes.firstWhere(
      (r) => r['value'] == rimType,
      orElse: () => rimTypes.first,
    );
    return List<String>.from(rim['compatibleTireTypes'] as List);
  }

  // Sistema de combustible
  static const List<String> fuelSystems = ['Carburada', 'Inyección electrónica'];

  // Tipos de transmisión
  static const List<Map<String, String>> transmissionTypes = [
    {
      'value': 'chain',
      'label': 'Cadena',
      'emoji': '⛓',
      'desc': 'Transmisión por cadena con piñón y corona. La más común.',
    },
    {
      'value': 'shaft',
      'label': 'Cardan',
      'emoji': '⚙️',
      'desc': 'Eje cardan sellado. Sin cadena ni piñones. Aceite diferencial cada 6,000 km.',
    },
    {
      'value': 'belt',
      'label': 'Correa / CVT',
      'emoji': '🔄',
      'desc': 'Automática con variador. Scooters y motos CVT. Sin palanca de clutch.',
    },
  ];

  // Tipos de cadena de transmisión
  static const List<Map<String, dynamic>> chainTypes = [
    {
      'value': 'standard',
      'label': 'Estándar (sin retén)',
      'lubKm': 500,
      'cleanKm': 600,
      'desc': 'Sin sellos entre eslabones. Requiere lubricación frecuente (~500 km). Se seca y desgasta rápido sin mantenimiento constante.',
    },
    {
      'value': 'o_ring',
      'label': 'O-Ring',
      'lubKm': 800,
      'cleanKm': 1000,
      'desc': 'Retenes circulares de goma entre eslabones. Retiene la grasa original más tiempo. Lubricar cada ~800 km.',
    },
    {
      'value': 'x_ring',
      'label': 'X-Ring',
      'lubKm': 1000,
      'cleanKm': 1200,
      'desc': 'Retenes en forma de X (4 puntos de contacto). Mejor sellado que O-ring, menor fricción. Lubricar cada ~1,000 km.',
    },
    {
      'value': 'w_ring',
      'label': 'W-Ring',
      'lubKm': 1200,
      'cleanKm': 1500,
      'desc': 'Variante premium del X-ring. Mayor durabilidad y sellado. Lubricar cada ~1,200 km.',
    },
  ];

  static Map<String, dynamic> chainTypeByValue(String value) =>
      chainTypes.firstWhere((t) => t['value'] == value,
          orElse: () => chainTypes.first);

  // Categorías de mantenimiento base (multi-select)
  // 'Calibración de válvulas' → solo 4T (filtrar en UI)
  // 'Carburador' / 'Inyección electrónica' → se agregan dinámicamente según fuelSystem
  static const Map<String, List<String>> maintenanceCategories = {
    'Motor': [
      'Cambio de aceite',
      'Cambio de filtro de aceite',
      'Bujías',
      'Calibración de válvulas (balancines/puntería)', // solo 4T
    ],
    'Filtros': [
      'Filtro de aire',
      'Filtro de gasolina',
    ],
    'Lubricación': [
      'Lubricación de cadena',
      'Limpieza de cadena',
      'Guaya / Cable de freno',
      'Guaya / Cable de clutch',
      'Guaya / Cable de acelerador',
      'Tasas / Eje delantero',
      'Eje trasero',
      'Tijera trasera (eje de horquilla)',
      'Tijeras delanteras (telescópicas)',
      'Rodamientos rueda delantera',
      'Rodamientos rueda trasera',
    ],
    'Clutch / Crochera': [
      'Discos de clutch / crochet',
      'Separadores de clutch',
      'Estrella / plato prensador',
      'Campana / canasta de clutch',
      'Maza / cubo de clutch',
      'Resortes de clutch',
      'Ajuste de clutch',
    ],
    'Suspensión delantera': [
      'Mantenimiento de barras convencionales',
      'Mantenimiento de barras invertidas',
      'Cambio de retenes de barras',
      'Cambio de guardapolvos de barras',
      'Cambio de aceite de barras',
      'Cambio de bujes de barras',
    ],
    'Rodamientos': [
      'Rodamiento rueda delantera',
      'Rodamiento rueda trasera',
      'Rodamiento de dirección',
      'Rodamiento tijera / basculante',
    ],
    'Frenos': [
      'Pastillas de freno',
      'Bandas de freno',
      'Líquido de frenos',
    ],
    'Eléctrico / Encendido': [
      'Magneto / estator',
      'CDI / ECU',
      'Regulador / rectificador',
      'Bobina de encendido',
      'Capuchón de bujía',
      'Arnés / conectores',
    ],
    'General': [
      'Revisión general',
      'Limpieza de tanque de gasolina',
      'Electrónica / Luces',
      'Suspensión trasera',
      'Otras partes',
    ],
  };

  // Items de mantenimiento por tipo de TRANSMISIÓN (se agregan dinámicamente)
  static const List<String> chainTransmissionItems = [
    'Ajuste / Tensión de cadena',
    'Piñón y Corona',
  ];

  static const List<String> shaftTransmissionItems = [
    'Revisión de nivel de aceite del cardan',
    'Cambio de aceite del cardan (SAE 80W-90)',
    'Inspección de juntas universales',
    'Inspección del eje de transmisión',
  ];

  static const List<String> beltCvtTransmissionItems = [
    'Inspección de correa de transmisión',
    'Cambio de correa de transmisión CVT',
    'Cambio de rodillos del variador',
    'Inspección del variador (polea motriz)',
    'Inspección campana / polea conducida',
    'Cambio de aceite de caja CVT',
    'Limpieza del filtro CVT',
  ];

  // Items exclusivos para motos CARBURADAS
  static const List<String> carbMaintenanceItems = [
    'Limpieza de carburador',
    'Ajuste de mezcla aire/combustible',
    'Sincronización de carburador',
    'Revisión del flotador y aguja',
    'Ajuste de marcha mínima (ralentí)',
  ];

  // Items exclusivos para motos con INYECCIÓN ELECTRÓNICA
  static const List<String> injectionMaintenanceItems = [
    'Limpieza de inyectores',
    'Revisión TPS / sensor de posición',
    'Revisión sensor MAP / presión',
    'Limpieza del cuerpo de aceleración',
    'Lectura / borrado de códigos de falla (OBD)',
    'Ajuste de ralentí electrónico',
  ];

  // Refacciones base 4T (sin partes de transmisión — se agregan según tipo)
  static const List<Map<String, dynamic>> defaultParts4T = [
    {'name': 'Aceite del motor',    'intervalKm': 3000,  'category': 'oil'},
    {'name': 'Filtro de aceite',    'intervalKm': 6000,  'category': 'oil_filter', 'filterType': 'replaceable'},
    {'name': 'Bujías',              'intervalKm': 8000,  'category': 'general'},
    {'name': 'Filtro de aire',      'intervalKm': 10000, 'category': 'general'},
    {'name': 'Filtro de gasolina',  'intervalKm': 12000, 'category': 'fuel_filter'},
    {'name': 'Freno delantero',     'intervalKm': 15000, 'category': 'brake_front', 'brakeType': 'pads'},
    {'name': 'Freno trasero',       'intervalKm': 12000, 'category': 'brake_rear',  'brakeType': 'pads'},
    {'name': 'Líquido de frenos',   'intervalKm': 20000, 'category': 'general'},
    {'name': 'Llanta delantera',    'intervalKm': 25000, 'category': 'tire'},
    {'name': 'Llanta trasera',      'intervalKm': 20000, 'category': 'tire'},
    {'name': 'Retenes de barras',    'intervalKm': 20000, 'category': 'fork'},
    {'name': 'Aceite de barras',     'intervalKm': 15000, 'category': 'fork'},
    {'name': 'Rodamientos rueda delantera', 'intervalKm': 25000, 'category': 'bearing'},
    {'name': 'Rodamientos rueda trasera',   'intervalKm': 25000, 'category': 'bearing'},
    {'name': 'Discos de clutch / crochet',  'intervalKm': 30000, 'category': 'clutch'},
    {'name': 'Separadores de clutch',       'intervalKm': 30000, 'category': 'clutch'},
    {'name': 'Estrella / plato prensador',  'intervalKm': 30000, 'category': 'clutch'},
    {'name': 'Magneto / estator',           'intervalKm': 40000, 'category': 'electrical'},
    {'name': 'CDI / ECU',                   'intervalKm': 40000, 'category': 'electrical'},
    {'name': 'Regulador / rectificador',    'intervalKm': 30000, 'category': 'electrical'},
    {'name': 'Batería',             'intervalKm': 30000, 'category': 'general'},
  ];

  // Refacciones base 2T (sin partes de transmisión)
  static const List<Map<String, dynamic>> defaultParts2T = [
    {'name': 'Bujías',              'intervalKm': 4000,  'category': 'general'},
    {'name': 'Filtro de aire',      'intervalKm': 8000,  'category': 'general'},
    {'name': 'Filtro de gasolina',  'intervalKm': 12000, 'category': 'fuel_filter'},
    {'name': 'Freno delantero',     'intervalKm': 15000, 'category': 'brake_front', 'brakeType': 'pads'},
    {'name': 'Freno trasero',       'intervalKm': 12000, 'category': 'brake_rear',  'brakeType': 'pads'},
    {'name': 'Líquido de frenos',   'intervalKm': 20000, 'category': 'general'},
    {'name': 'Llanta delantera',    'intervalKm': 25000, 'category': 'tire'},
    {'name': 'Llanta trasera',      'intervalKm': 20000, 'category': 'tire'},
    {'name': 'Retenes de barras',    'intervalKm': 20000, 'category': 'fork'},
    {'name': 'Aceite de barras',     'intervalKm': 15000, 'category': 'fork'},
    {'name': 'Rodamientos rueda delantera', 'intervalKm': 25000, 'category': 'bearing'},
    {'name': 'Rodamientos rueda trasera',   'intervalKm': 25000, 'category': 'bearing'},
    {'name': 'Discos de clutch / crochet',  'intervalKm': 30000, 'category': 'clutch'},
    {'name': 'Separadores de clutch',       'intervalKm': 30000, 'category': 'clutch'},
    {'name': 'Estrella / plato prensador',  'intervalKm': 30000, 'category': 'clutch'},
    {'name': 'Magneto / estator',           'intervalKm': 40000, 'category': 'electrical'},
    {'name': 'CDI / ECU',                   'intervalKm': 40000, 'category': 'electrical'},
    {'name': 'Regulador / rectificador',    'intervalKm': 30000, 'category': 'electrical'},
    {'name': 'Batería',             'intervalKm': 30000, 'category': 'general'},
  ];

  // Partes por tipo de TRANSMISIÓN
  static const List<Map<String, dynamic>> chainDefaultParts = [
    {'name': 'Cadena de transmisión', 'intervalKm': 5000,  'category': 'chain'},
    {'name': 'Piñón delantero',       'intervalKm': 10000, 'category': 'sprocket'},
    {'name': 'Corona trasera',        'intervalKm': 10000, 'category': 'sprocket'},
    {'name': 'Gomas porta corona',    'intervalKm': 15000, 'category': 'general'},
  ];

  static const List<Map<String, dynamic>> shaftDefaultParts = [
    {'name': 'Aceite del cardan (SAE 80W-90)', 'intervalKm': 6000, 'category': 'shaft_oil'},
  ];

  static const List<Map<String, dynamic>> beltCvtDefaultParts = [
    {'name': 'Correa de transmisión CVT', 'intervalKm': 15000, 'category': 'belt'},
    {'name': 'Rodillos del variador',     'intervalKm': 12000, 'category': 'belt'},
    {'name': 'Aceite de caja CVT',        'intervalKm': 6000,  'category': 'transmission_oil'},
  ];

  static List<Map<String, dynamic>> get defaultParts => defaultParts4T;

  static const String appName = 'MotoCheck';
}
