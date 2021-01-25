import common::*;
import defs::*;

module Fetch (
    input  context_t   ctx,
    output context_t   out,
    output ibus_req_t  ireq,
    input  ibus_resp_t iresp
);
    /**
     * out:
     *   t[0]: responded data
     */

    assign ireq.valid = 1;
    assign ireq.size = MSIZE4;
    assign ireq.addr = ctx.pc;

    always_comb begin
        out = ctx;
        out.t[0] = iresp.data;

        if (iresp.addr_ok && iresp.data_ok)
            out.state = S_DECODE;
        else if (iresp.addr_ok)
            out.state = S_FETCH_ADDR_SENT;
        else
            out.state = S_FETCH;
    end
endmodule
