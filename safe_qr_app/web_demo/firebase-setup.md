# 🔥 Configuração do Firebase - Safe QR Demo

## 📋 Passo a Passo para Configurar

### 1️⃣ **Criar Projeto no Firebase**

#### **Acesse o Console:**
1. Vá para [console.firebase.google.com](https://console.firebase.google.com)
2. Clique em **"Adicionar projeto"**
3. Nome do projeto: `safe-qr-demo` (ou qualquer nome)
4. Desabilite Google Analytics (opcional)
5. Clique em **"Criar projeto"**

### 2️⃣ **Configurar Firestore Database**

#### **Criar Database:**
1. No painel lateral, clique em **"Firestore Database"**
2. Clique em **"Criar banco de dados"**
3. Escolha **"Começar no modo de teste"** (para demonstração)
4. Escolha uma localização (us-central1 recomendado)
5. Clique em **"Concluído"**

#### **Configurar Regras (Importante):**
```javascript
// Cole isso nas regras do Firestore:
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permite leitura e escrita para demonstração
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

### 3️⃣ **Obter Configurações do Projeto**

#### **Configurações do App:**
1. Clique no ícone de **engrenagem** (Configurações do projeto)
2. Role para baixo até **"Seus aplicativos"**
3. Clique em **"</>" (Web)**
4. Nome do app: `safe-qr-demo-web`
5. **NÃO** marque "Também configurar Firebase Hosting"
6. Clique em **"Registrar app"**

#### **Copie as Configurações:**
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "seu-projeto-id.firebaseapp.com",
  projectId: "seu-projeto-id",
  storageBucket: "seu-projeto-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

### 4️⃣ **Atualizar o Arquivo HTML**

#### **Edite o arquivo `firebase-demo.html`:**
```javascript
// Substitua esta seção (linha ~200):
const firebaseConfig = {
    apiKey: "SUA_API_KEY_AQUI",
    authDomain: "seu-projeto.firebaseapp.com",
    projectId: "seu-projeto-id",
    storageBucket: "seu-projeto.appspot.com",
    messagingSenderId: "123456789",
    appId: "1:123456789:web:abcdef123456"
};

// PELAS SUAS CONFIGURAÇÕES REAIS:
const firebaseConfig = {
    apiKey: "AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
    authDomain: "seu-projeto-id.firebaseapp.com",
    projectId: "seu-projeto-id",
    storageBucket: "seu-projeto-id.appspot.com",
    messagingSenderId: "123456789012",
    appId: "1:123456789012:web:abcdef1234567890"
};
```

### 5️⃣ **Testar a Configuração**

#### **Deploy do Site:**
1. **Netlify** (recomendado):
   - Acesse [netlify.com](https://netlify.com)
   - Arraste a pasta `web_demo`
   - Aguarde o deploy
   - Copie a URL gerada

2. **GitHub Pages**:
   - Crie repositório no GitHub
   - Faça upload dos arquivos
   - Ative GitHub Pages
   - Use a URL gerada

#### **Teste Básico:**
1. Abra o site no navegador
2. Veja se aparece **"✅ Conectado ao Firebase"**
3. Preencha o formulário
4. Clique em "Finalizar Pedido"
5. Veja se aparece **"Dados Enviados para Firebase"**

### 6️⃣ **Verificar Dados no Firebase**

#### **No Console do Firebase:**
1. Vá para **"Firestore Database"**
2. Clique em **"Dados"**
3. Veja a collection **"qr_demo_data"**
4. Clique nos documentos para ver os dados

#### **Estrutura dos Dados:**
```json
{
  "timestamp": "27/09/2025 15:30:45",
  "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...",
  "language": "pt-BR",
  "platform": "Win32",
  "screenResolution": "1920x1080",
  "timezone": "America/Sao_Paulo",
  "cookiesEnabled": true,
  "onlineStatus": true,
  "referrer": "https://google.com",
  "formData": {
    "name": "João Silva",
    "email": "joao@email.com",
    "phone": "(11) 99999-9999",
    "address": "Rua das Flores, 123",
    "cardNumber": "1234 5678 9012 3456",
    "cvv": "123"
  },
  "dataType": "form_submission",
  "firebaseTimestamp": "2025-09-27T18:30:45.123Z",
  "documentId": "auto-generated"
}
```

## 🎯 **Casos de Uso para Demonstração**

### 👨‍🏫 **Para Educadores:**
- **Mostre em tempo real** como dados são coletados
- **Acesse o Firebase** durante a apresentação
- **Demonstre os riscos** de QR Codes maliciosos
- **Compare com sites legítimos**

### 🏢 **Para Empresas:**
- **Treinamento de funcionários** sobre segurança
- **Awareness de phishing** e ataques
- **Políticas de segurança** digitais
- **Testes de conscientização**

### 👥 **Para Comunidades:**
- **Palestras sobre segurança** digital
- **Workshops práticos** de proteção
- **Eventos de tecnologia** e inovação
- **Demonstrações interativas**

## 🔒 **Considerações de Segurança**

### ✅ **Para Demonstração:**
- **Regras abertas** no Firestore (apenas para demo)
- **Dados fictícios** nos formulários
- **Avisos claros** sobre ser demonstração
- **Fins educacionais** apenas

### ⚠️ **Em Produção:**
- **Regras restritivas** no Firestore
- **Autenticação** obrigatória
- **Validação** de dados
- **Logs de auditoria**

## 📊 **Analytics e Monitoramento**

### 🔍 **No Firebase Console:**
- **Usage** - Quantos documentos foram criados
- **Performance** - Tempo de resposta
- **Errors** - Erros de conexão
- **Security** - Tentativas de acesso

### 📈 **Métricas Úteis:**
- **Dados coletados por sessão**
- **Tempo médio na página**
- **Taxa de preenchimento do formulário**
- **Dispositivos mais comuns**

## 🚀 **Deploy e Compartilhamento**

### 📱 **Gerar QR Code:**
1. Use qualquer gerador de QR Code
2. URL: `https://sua-url-aqui.com/firebase-demo.html`
3. Teste com o Safe QR App
4. Compartilhe para demonstrações

### 🎯 **Para Apresentações:**
1. **Abra o Firebase Console** em uma aba
2. **Abra o site** em outra aba
3. **Mostre a coleta** em tempo real
4. **Demonstre os riscos** de segurança

## 🔧 **Troubleshooting**

### ❌ **Problemas Comuns:**

#### **"Firebase não inicializado":**
- Verifique se as configurações estão corretas
- Confirme se o projeto existe no Firebase
- Teste se o Firestore está ativo

#### **"Erro ao enviar para Firebase":**
- Verifique as regras do Firestore
- Confirme se está em modo de teste
- Teste a conexão com internet

#### **"Dados não aparecem no Firebase":**
- Aguarde alguns segundos
- Atualize a página do Firebase Console
- Verifique se não há erros no console

### ✅ **Soluções:**
- **Teste localmente** primeiro
- **Use HTTPS** para melhor compatibilidade
- **Verifique logs** do console do navegador
- **Confirme configurações** do Firebase

---

**🔥 Com essa configuração, você terá uma demonstração completa e impactante mostrando como QR Codes maliciosos podem coletar dados em tempo real!**
