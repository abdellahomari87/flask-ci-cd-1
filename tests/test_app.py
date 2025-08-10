import unittest
from app import app

class FlaskAppTestCase(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_hello(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode(), "Hello, CI/CD!")

if __name__ == '__main__':
    unittest.main()
