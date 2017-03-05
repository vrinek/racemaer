import json as json
import tensorflow as tf

with open("sensors_ml.json") as file:
    sensors = json.loads(file.read())

input_size = len(sensors[0])

with open("commands_ml.json") as file:
    commands = json.loads(file.read())

output_size = len(commands[0])

# Define model
x = tf.placeholder(tf.float32, [None, input_size])

W = tf.Variable(tf.random_uniform([input_size, output_size]))
b = tf.Variable(tf.random_uniform([output_size]))
y = tf.sigmoid(tf.matmul(x, W) + b)

# Define loss and optimizer
y_ = tf.placeholder(tf.float32, [None, output_size])

loss = tf.reduce_mean(tf.squared_difference(y_, y))

train_step = tf.train.GradientDescentOptimizer(0.5).minimize(loss)

sess = tf.Session()
sess.run(tf.global_variables_initializer())

for epoch in range(100):
    print(epoch, sess.run(loss, feed_dict={x: sensors, y_: commands}))
    for _ in range(100):
        sess.run(train_step, feed_dict={x: sensors, y_: commands})

json_data = json.dumps({
    'W': sess.run(W).tolist(),
    'b': sess.run(b).tolist(),
})

with open("parameters.json", 'w') as file:
    file.write(json_data)

print(sess.run(loss, feed_dict={x: sensors, y_: commands}))
