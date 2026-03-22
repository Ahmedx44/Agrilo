const jwt = require('jsonwebtoken');
const User = require('../models/user.model');

const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists.' });
    }

    const user = new User({ name, email, password });
    await user.save();

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.status(201).json({
      message: 'User registered successfully.',
      user: { id: user._id, name: user.name, email: user.email },
      token
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Error registering user.' });
  }
};

const login = async (req, res) => {
  try {
     const { email, password } = req.body;
     const user = await User.findOne({ email }).select('+password');
     if (!user) {
        return res.status(400).json({ message: 'Invalid credentials.' });
     }

     const isMatch = await user.comparePassword(password);
     if (!isMatch) {
        return res.status(400).json({ message: 'Invalid credentials.' });
     }

     const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
     res.json({
        message: 'Login successful.',
        user: { id: user._id, name: user.name, email: user.email },
        token
     });
  } catch (error) {
     console.error('Login error:', error);
     res.status(500).json({ message: 'Error logging in.' });
  }
};

module.exports = { register, login };
