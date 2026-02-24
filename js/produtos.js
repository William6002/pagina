// =============================================
// produtos.js — Catálogo de produtos (dados)
// =============================================

const PRODUTOS_DB = [
  { id: 1, nome: "Painel de Controle CLP",  descricao: "Controlador lógico programável para automação industrial.",  preco: 3200.00, unidade: "unid.", categoria: "Automação", icone: "🖥️" },
  { id: 2, nome: "Motor Elétrico Trifásico", descricao: "Motor industrial trifásico 5CV de alta eficiência.",         preco: 1800.00, unidade: "unid.", categoria: "Motores",    icone: "⚙️" },
  { id: 3, nome: "Inversor de Frequência",   descricao: "Controle de velocidade de motores CC e CA.",                 preco: 2500.00, unidade: "unid.", categoria: "Automação", icone: "🔌" },
  { id: 4, nome: "Sensor Indutivo",          descricao: "Sensor de proximidade indutivo NPN 12-24VDC.",               preco:  280.00, unidade: "unid.", categoria: "Sensores",  icone: "📡" },
  { id: 5, nome: "Chave Termomagnética 3P",  descricao: "Disjuntor tripolar 63A para proteção de circuitos.",        preco:  420.00, unidade: "unid.", categoria: "Proteção",  icone: "🛡️" },
  { id: 6, nome: "Cabo Flexível PP 4mm²",    descricao: "Rolo com 100m de cabo PP flexível para uso industrial.",    preco:  950.00, unidade: "rolo",  categoria: "Cabos",     icone: "🔗" },
  { id: 7, nome: "Interface HMI 7\"",         descricao: "Interface homem-máquina touchscreen 7 polegadas.",          preco: 1650.00, unidade: "unid.", categoria: "Automação", icone: "📱" },
  { id: 8, nome: "Relé de Proteção",          descricao: "Relé temporizador e de proteção multi-função.",            preco:  380.00, unidade: "unid.", categoria: "Proteção",  icone: "⚡" },
];

// Renderiza cards na landing page
function renderProdutosLanding() {
  const grid = document.getElementById('produtosGrid');
  if (!grid) return;
  grid.innerHTML = PRODUTOS_DB.map(p => `
    <div class="produto-card">
      <div class="produto-icon">${p.icone}</div>
      <h3>${p.nome}</h3>
      <p>${p.descricao}</p>
      <div class="produto-price">R$ ${p.preco.toLocaleString('pt-BR', {minimumFractionDigits:2})}<span style="font-size:.75rem;font-weight:400;color:var(--text-muted);"> / ${p.unidade}</span></div>
    </div>
  `).join('');
}

// Renderiza lista com checkboxes para orçamento
function renderProdutosSeletor(containerId) {
  const el = document.getElementById(containerId);
  if (!el) return;
  el.innerHTML = PRODUTOS_DB.map(p => `
    <label class="produto-sel" data-id="${p.id}">
      <input type="checkbox" value="${p.id}" name="produtos[]" />
      <div class="check-badge">✓</div>
      <div class="produto-icon" style="font-size:1.5rem;margin-bottom:.5rem;">${p.icone}</div>
      <strong style="font-family:var(--font-head);font-size:.95rem;">${p.nome}</strong>
      <p style="font-size:.8rem;color:var(--text-muted);margin:.3rem 0 0;">${p.categoria} · R$ ${p.preco.toLocaleString('pt-BR',{minimumFractionDigits:2})}</p>
      <div class="qty-row">
        <label>Qtd:</label>
        <input type="number" class="qty-input" min="1" value="1" data-id="${p.id}" onclick="event.stopPropagation()">
      </div>
    </label>
  `).join('');

  // Toggle selection
  el.querySelectorAll('.produto-sel').forEach(card => {
    card.addEventListener('click', () => {
      card.classList.toggle('selected');
      const cb = card.querySelector('input[type="checkbox"]');
      cb.checked = card.classList.contains('selected');
      updateOrcamentoResumo();
    });
  });

  el.querySelectorAll('.qty-input').forEach(input => {
    input.addEventListener('input', updateOrcamentoResumo);
  });
}

function getProdutoById(id) {
  return PRODUTOS_DB.find(p => p.id === parseInt(id));
}

document.addEventListener('DOMContentLoaded', renderProdutosLanding);
