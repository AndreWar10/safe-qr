# 🚀 Guia de Deploy - Demonstração Safe QR

## 📋 Opções de Hospedagem

### 1️⃣ GitHub Pages (Gratuito)
```bash
# 1. Crie um repositório no GitHub
# 2. Faça upload dos arquivos
# 3. Vá em Settings > Pages
# 4. Selecione "Deploy from a branch"
# 5. Escolha "main" branch
# 6. Acesse: https://seu-usuario.github.io/nome-repositorio
```

### 2️⃣ Netlify (Gratuito)
```bash
# 1. Acesse netlify.com
# 2. Faça login com GitHub
# 3. Arraste a pasta web_demo
# 4. Aguarde o deploy automático
# 5. Personalize o domínio se desejar
```

### 3️⃣ Vercel (Gratuito)
```bash
# 1. Acesse vercel.com
# 2. Conecte com GitHub
# 3. Importe o repositório
# 4. Configure build settings
# 5. Deploy automático
```

### 4️⃣ Servidor Local
```bash
# Python
cd safe_qr_app/web_demo
python -m http.server 8000
# Acesse: http://localhost:8000

# Node.js
npx serve safe_qr_app/web_demo
# Acesse: http://localhost:3000

# PHP
cd safe_qr_app/web_demo
php -S localhost:8000
# Acesse: http://localhost:8000
```

## 🔧 Configurações Recomendadas

### ✅ HTTPS Obrigatório
- **Geolocalização** só funciona com HTTPS
- **Melhor segurança** para demonstração
- **Compatibilidade** com todos os recursos

### ✅ Domínio Personalizado
- **Mais profissional** para demonstrações
- **Fácil de lembrar** para apresentações
- **Credibilidade** para fins educacionais

### ✅ Cache Headers
```html
<!-- Adicione ao <head> se necessário -->
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
```

## 📱 Testando o Deploy

### 1️⃣ Teste Básico
- ✅ Site carrega corretamente
- ✅ Layout responsivo funciona
- ✅ Formulário funciona
- ✅ JavaScript executa

### 2️⃣ Teste de QR Code
- ✅ Gere QR Code com a URL
- ✅ Teste em diferentes dispositivos
- ✅ Verifique redirecionamento
- ✅ Confirme coleta de dados

### 3️⃣ Teste com Safe QR App
- ✅ Escaneie o QR Code
- ✅ Verifique análise de segurança
- ✅ Confirme avisos de risco
- ✅ Teste bloqueio (se implementado)

## 🎯 URLs de Exemplo

### Para demonstrações:
```
https://safe-qr-demo.netlify.app
https://pizzaria-bella-vista.vercel.app
https://seu-usuario.github.io/safe-qr-demo
```

### Para testes locais:
```
http://localhost:8000
http://192.168.1.100:8000 (rede local)
```

## 📊 Analytics (Opcional)

### Google Analytics
```html
<!-- Adicione antes do </head> -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### Hotjar (Heatmaps)
```html
<!-- Adicione antes do </head> -->
<script>
  (function(h,o,t,j,a,r){
      h.hj=h.hj||function(){(h.hj.q=h.hj.q||[]).push(arguments)};
      h._hjSettings={hjid:YOUR_HOTJAR_ID,hjsv:6};
      a=o.getElementsByTagName('head')[0];
      r=o.createElement('script');r.async=1;
      r.src=t+h._hjSettings.hjid+j+h._hjSettings.hjsv;
      a.appendChild(r);
  })(window,document,'https://static.hotjar.com/c/hotjar-','.js?sv=');
</script>
```

## 🔒 Segurança do Deploy

### ✅ Configurações de Segurança
- **HTTPS obrigatório**
- **Headers de segurança**
- **Validação de entrada**
- **Sanitização de dados**

### ✅ Monitoramento
- **Logs de acesso**
- **Tentativas de ataque**
- **Uso anômalo**
- **Alertas de segurança**

## 📈 Performance

### ✅ Otimizações
- **Compressão GZIP**
- **Cache de recursos**
- **Minificação CSS/JS**
- **Otimização de imagens**

### ✅ Métricas
- **Tempo de carregamento**
- **Core Web Vitals**
- **Mobile performance**
- **Acessibilidade**

## 🎨 Personalização

### ✅ Branding
- **Logo personalizado**
- **Cores da empresa**
- **Texto customizado**
- **Domínio próprio**

### ✅ Funcionalidades
- **Campos adicionais**
- **Integrações externas**
- **Analytics avançados**
- **Relatórios personalizados**

## 📞 Suporte Técnico

### Problemas Comuns:
1. **Site não carrega** - Verifique DNS e servidor
2. **HTTPS não funciona** - Configure certificado SSL
3. **QR Code não redireciona** - Verifique URL
4. **Mobile não funciona** - Teste responsividade

### Soluções:
- ✅ Verifique logs do servidor
- ✅ Teste em diferentes navegadores
- ✅ Confirme configurações de rede
- ✅ Valide certificados SSL

---

**🚀 Com essas configurações, sua demonstração estará pronta para impressionar e educar sobre os riscos de QR Codes maliciosos!**
