module.exports = {
  devServer: {
    proxy: {
      '/dev': {
        target: 'http://localhost:8080/v1',
        changeOrigin: true,
      },
    },
  },
  configureWebpack: {
    module: {
      rules: [
        {
          test: /config.*config\.js$/,
          use: [
            {
              loader: 'file-loader',
              options: {
                name: 'config.js',
              },
            },
          ],
        },
      ],
    },
  },
};
