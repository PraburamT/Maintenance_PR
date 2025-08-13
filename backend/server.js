const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const xml2js = require('xml2js');
const https = require('https');

const app = express();

// Add CORS middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
  } else {
    next();
  }
});

app.use(bodyParser.json());

// SAP credentials
const SAP_USERNAME = 'k901673';
const SAP_PASSWORD = 'Tpraburam733@';

// SAP URLs
const SAP_LOGIN_URL = 'https://AZKTLDS5CP.kcloud.com:44300/sap/opu/odata/SAP/ZMAIN_ODATA_PR_SRV/MAINLOGINSet';
const SAP_PLANT_URL = 'http://AZKTLDS5CP.kcloud.com:8000/sap/opu/odata/SAP/ZMAIN_ODATA_PR_SRV/MAINPLANTSet';
const SAP_NOTIFY_URL = "https://AZKTLDS5CP.kcloud.com:44300/sap/opu/odata/SAP/ZMAIN_ODATA_PR_SRV/MAINNOTIFYSet?$filter=Iwerk eq '0001'";
const SAP_MAINWORK_URL = "https://AZKTLDS5CP.kcloud.com:44300/sap/opu/odata/SAP/ZMAIN_ODATA_PR_SRV/MAINWORKSet?$filter=Werks eq '0001'";


// HTTPS agent for self-signed certs
const httpsAgent = new https.Agent({ rejectUnauthorized: false });

// ======================= LOGIN ROUTE =======================
app.post('/maintenance-login', async (req, res) => {
  const { EmpId, Password } = req.body;
  const authHeader = 'Basic ' + Buffer.from(`${SAP_USERNAME}:${SAP_PASSWORD}`).toString('base64');

  try {
    const csrfRes = await axios.get(
      'https://AZKTLDS5CP.kcloud.com:44300/sap/opu/odata/SAP/ZMAIN_ODATA_PR_SRV/$metadata',
      {
        headers: {
          'Authorization': authHeader,
          'x-csrf-token': 'Fetch'
        },
        httpsAgent
      }
    );

    const csrfToken = csrfRes.headers['x-csrf-token'];
    const cookies = csrfRes.headers['set-cookie'];

    if (!csrfToken || !cookies) {
      return res.status(500).json({ error: 'Failed to fetch CSRF token or session cookies' });
    }

    const postHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/atom+xml',
      'Authorization': authHeader,
      'x-csrf-token': csrfToken,
      'Cookie': cookies.join(';')
    };

    const loginPayload = { EmpId, Password };

    const postRes = await axios.post(SAP_LOGIN_URL, loginPayload, {
      headers: postHeaders,
      httpsAgent
    });

    const parsed = await xml2js.parseStringPromise(postRes.data, { explicitArray: false });
    const props = parsed?.entry?.content?.['m:properties'];

    const result = {
      EmpId: props?.['d:EmpId'],
      Message: props?.['d:return']
    };

    res.json(result);
  } catch (error) {
    console.error('Login failed:', error?.response?.data || error.message);
    res.status(500).json({
      error: 'Login failed',
      details: error?.response?.data || error.message
    });
  }
});

// ======================= PLANT LIST ROUTE =======================
app.get('/plant-list', async (req, res) => {
  const authHeader = 'Basic ' + Buffer.from(`${SAP_USERNAME}:${SAP_PASSWORD}`).toString('base64');

  try {
    const response = await axios.get(SAP_PLANT_URL, {
      headers: {
        'Authorization': authHeader,
        'Accept': 'application/atom+xml'
      }
    });

    const parsed = await xml2js.parseStringPromise(response.data, { explicitArray: false });
    const entries = parsed?.feed?.entry;

    const entryArray = Array.isArray(entries) ? entries : [entries];

    const plants = entryArray.map(entry => {
      const props = entry?.content?.['m:properties'];
      return {
        Werks: props?.['d:Werks'],
        Name1: props?.['d:Name1'],
        Name2: props?.['d:Name2'],
        Street: props?.['d:Stras'],
        City: props?.['d:Ort01'],
        Region: props?.['d:Regio'],
        PostalCode: props?.['d:Pstlz'],
        Country: props?.['d:Land1']
      };
    });

    res.json(plants);
  } catch (error) {
    console.error('Plant list fetch failed:', error?.response?.data || error.message);
    res.status(500).json({
      error: 'Failed to fetch plant list',
      details: error?.response?.data || error.message
    });
  }
});

// ======================= NOTIFY LIST ROUTE =======================
app.get('/notify-list', async (req, res) => {
  const authHeader = 'Basic ' + Buffer.from(`${SAP_USERNAME}:${SAP_PASSWORD}`).toString('base64');

  try {
    const response = await axios.get(SAP_NOTIFY_URL, {
      headers: {
        'Authorization': authHeader,
        'Accept': 'application/atom+xml'
      },
      httpsAgent
    });

    const parsed = await xml2js.parseStringPromise(response.data, { explicitArray: false });
    const entries = parsed?.feed?.entry;

    if (!entries) {
      return res.json([]);
    }

    const entryArray = Array.isArray(entries) ? entries : [entries];

    const notifications = entryArray.map(entry => {
      const props = entry?.content?.['m:properties'];
      return {
        Qmnum: props?.['d:Qmnum'],
        Iwerk: props?.['d:Iwerk'],
        Equipment: props?.['d:Equnr'],
        Ingrp: props?.['d:Ingrp'],
        CreatedOn: props?.['d:Ausvn'],
        QmType: props?.['d:Qmart'],
        Duration: props?.['d:Auztv'],
        Artpr: props?.['d:Artpr'],
        Description: props?.['d:Qmtxt'],
        Priority: props?.['d:Priok'],
        WorkcenterPlant: props?.['d:Arbplwerk']
      };
    });

    res.json(notifications);

  } catch (error) {
    console.error('Notify list fetch failed:', error?.response?.data || error.message);
    res.status(500).json({
      error: 'Failed to fetch notify list',
      details: error?.response?.data || error.message
    });
  }
});

app.get('/main-work', async (req, res) => {
  const authHeader = 'Basic ' + Buffer.from(`${SAP_USERNAME}:${SAP_PASSWORD}`).toString('base64');

  try {
    const response = await axios.get(SAP_MAINWORK_URL, {
      headers: {
        'Authorization': authHeader,
        'Accept': 'application/atom+xml'
      },
      httpsAgent
    });

    const parsed = await xml2js.parseStringPromise(response.data, { explicitArray: false });
    const entries = parsed?.feed?.entry;

    if (!entries) {
      return res.json([]);
    }

    const entryArray = Array.isArray(entries) ? entries : [entries];

    const works = entryArray.map(entry => {
      const props = entry?.content?.['m:properties'];
      return {
        Aufnr: props?.['d:Aufnr'],        // Work Order Number
        Werks: props?.['d:Werks'],        // Plant
        Arbpl: props?.['d:Arbpl'],        // Work Center
        Auart: props?.['d:Auart'],        // Order Type
        Ktext: props?.['d:Ktext'],        // Description
        Gstrp: props?.['d:Gstrp'],        // Start Date
        Gltrp: props?.['d:Gltrp'],        // End Date
        Ilart: props?.['d:Ilart']         // Maintenance Activity Type
      };
    });

    res.json(works);

  } catch (error) {
    console.error('Main work fetch failed:', error?.response?.data || error.message);
    res.status(500).json({
      error: 'Failed to fetch main work',
      details: error?.response?.data || error.message
    });
  }
});

// ======================= START SERVER =======================
app.listen(3000, () => {
  console.log('✅ Server running at http://localhost:3000');
});
