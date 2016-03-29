import numpy as np

class ANN:

    LEARN_ITERATIONS = 60000

    def __init__(self):
        self.X = np.array([[1,0],[0,0],[0,0]])
        self.y = np.array([[1],[0],[0]])
        np.random.seed(1)

        # randomly initialize our weights with mean 0
        #self.syn0 = 2*np.random.random((2,3)) - 1
        #self.syn1 = 2*np.random.random((3,1)) - 1

        # 2ez4me
        self.syn0 = [[-1.68908207, -1.67388583,  4.00059522],
                    [ 2.40624477,  3.42700534, -5.52693725]]
        self.syn1 = [[-10.6303791 ],
                    [-12.34892854],
                    [ 11.61118677]]

    def nonlin(self, x, deriv=False):
        if(deriv): return x*(1-x)
        return 1/(1+np.exp(-x))

    def learn(self, input_layer, output_layer):
        self.X = np.array(input_layer)
        self.y = np.array(output_layer)
        self.backprop(self.LEARN_ITERATIONS)

    def predict(self, case):
        l0 = case
        l1 = self.nonlin(np.dot(l0, self.syn0))
        l2 = self.nonlin(np.dot(l1, self.syn1))
        return l2

    def backprop(self, iterations=LEARN_ITERATIONS):
        for j in range(iterations):
            # Feed forward through layers 0, 1, and 2
            l0 = self.X
            l1 = self.nonlin(np.dot(l0,self.syn0))
            l2 = self.nonlin(np.dot(l1,self.syn1))
            # how much did we miss the target value?
            l2_error = self.y - l2
            if (j% 10000) == 0:
                print("Error:" + str(np.mean(np.abs(l2_error))))
            # in what direction is the target value?
            # were we really sure? if so, don't change too much.
            l2_delta = l2_error*self.nonlin(l2,deriv=True)
            # how much did each l1 value contribute to the l2 error (according to the weights)?
            l1_error = l2_delta.dot(self.syn1.T)
            # in what direction is the target l1?
            # were we really sure? if so, don't change too much.
            l1_delta = l1_error * self.nonlin(l1,deriv=True)
            self.syn1 += l1.T.dot(l2_delta)
            self.syn0 += l0.T.dot(l1_delta)
