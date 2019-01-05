# -*-coding:utf-8-*-

import cython
import numpy as np
cdef extern from "math.h":
    cpdef double exp(double x)
    cpdef double log(double x)

def log_likelihood(double y1,
                   double y0,
                   double theta,
                   double alpha,
                   double beta,
                   double c=0.0):
    '''
    same for 2PL and 3PL
    '''
    expPos = exp(alpha * theta + beta) ;
    ell =  y1 * log((c + expPos) / (1.0 + expPos)) + y0 * log((1.0 - c) / (1.0 + expPos)) ;
    return ell


def log_likelihood_gradient(double y1,
                            double y0,
                            double theta,
                            double alpha,
                            double beta,
                            double c=0.0,
                            model_spec='2PL'):
    if model_spec == '3PL':
      grad = np.zeros(3)
    else:
      grad = np.zeros(2)

    # It is the gradient of the log likelihood, not the NEGATIVE log likelihood
    temp = exp(beta + alpha * theta)
    beta_grad = temp / (1.0 + temp) * ( y1 * (1.0 - c) / (c + temp) - y0)

    alpha_grad = theta * beta_grad
    grad[0] = beta_grad
    grad[1] = alpha_grad
    if model_spec == '3PL':
      c_grad = y1 / (c + temp) - y0 / (1 - c)
      grad[2] = c_grad

    return grad
